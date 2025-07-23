let map;
const placeCache = new Map();
const markerMap = new Map();

function initMap() {
  // Leafletの地図を初期化
  map = L.map("map", {zoomControl: false,}).setView([35.681, 139.767], 13); // 東京駅を中心に設定

  // OpenStreetMapのタイルを追加
  L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
    attribution: '© OpenStreetMap contributors'
  }).addTo(map);

  // 現在地を取得
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(
      position => {
        const lat = position.coords.latitude; // 緯度
        const lon = position.coords.longitude; // 経度
        const currentLocation = [lat, lon];

        // 地図の中心を現在地に変更
        map.setView(currentLocation, 13);

        // 現在地にマーカーを追加
        L.marker(currentLocation).addTo(map).bindPopup("現在地").openPopup();

        // スイーツ店を検索
        findSweets(currentLocation);
        fetchAndDisplayNearbyCards(lat, lon);
      },
      () => {
        alert("位置情報の取得に失敗しました");
      }
    );
  } else {
    alert("このブラウザは位置情報に対応していません");
  }
  setupCardClickEvents();
}

async function findSweets(location) {
  const requests = [
    { query: '["amenity"="cafe"]', icon: "☕" }, // カフェ
    { query: '["shop"="confectionery"]', icon: "🍡" }, // 和菓子・お菓子専門店
    { query: '["shop"="bakery"]', icon: "🥐" }, // パン屋
    { query: '["shop"="pastry"]', icon: "🍰" }
  ];

  for (const request of requests) {
    try {
      const results = await fetchPlaces(location, request.query);
      results.forEach(place => {
        if (placeCache.has(place.id)) {
          console.log(`キャッシュから取得: ${place.name}`);
          displayMarker(placeCache.get(place.id), request.icon);
        } else {
          console.log(`新規取得: ${place.name}`);
          placeCache.set(place.id, place);
          // 店舗情報を保存
          saveStoreToDatabase(place);

          // マーカーを表示
          displayMarker(place, request.icon);
        }
      });
    } catch (error) {
      console.error("場所の検索中にエラーが発生しました:", error);
    }
  }
  console.log("キャッシュの内容:", Array.from(placeCache.entries()));
}

async function fetchPlaces(location, query) {
  const [lat, lon] = location;
  const radius = 4500; // 半径4500m

  // Overpass APIを利用して周辺の場所を検索
  const url = `https://overpass-api.de/api/interpreter?data=[out:json];node${query}(around:${radius},${lat},${lon});out body;`;
  const response = await fetch(url);
  const data = await response.json();
  console.log(`クエリ: ${query}, 結果数: ${data.elements.length}`, data.elements);

  console.log(JSON.stringify(data.elements, null, 2));
  return data.elements.map(element => ({
    id: element.id,
    place_id: element.id,
    name: element.tags.name || "名前不明",
    lat: element.lat,
    lon: element.lon,
    tags: element.tags
  }));
}

async function getAddress(lat, lon) {
  const url = `https://nominatim.openstreetmap.org/reverse?lat=${lat}&lon=${lon}&format=json`;

  const response = await fetch(url);
  if (!response.ok) {
    throw new Error("ネットワークエラーが発生しました");
  }

  const data = await response.json();

  if (data.address) {
    return data.display_name;
  } else {
    return "住所が見つかりませんでした";
  }
}

async function displayMarker(place, iconType) {
  const placeId = place.place_id;

  if (!placeId) {
    console.error("placeIdが未定義です:", place);
    return;
  }
  const iconUrls = {
    "🍡": "https://iconbu.com/wp-content/uploads/2023/01/%E3%81%84%E3%81%A1%E3%81%94%E5%A4%A7%E7%A6%8F.jpg",
    "☕": "https://owl-stock.work/wp-content/uploads/2021/08/01385-tmb.png",
    "🍰": "https://iconbu.com/wp-content/uploads/2021/05/%E3%82%B1%E3%83%BC%E3%82%AD%E3%81%AE%E3%82%A2%E3%82%A4%E3%82%B3%E3%83%B3.jpg",
    "🥐": "https://iconbu.com/wp-content/uploads/2020/06/%E3%83%91%E3%83%B3%E3%82%B1%E3%83%BC%E3%82%AD%E3%81%AE%E3%82%A4%E3%83%A9%E3%82%B9%E3%83%88.jpg",
  };

  const iconUrl = iconUrls[iconType];

  const customIcon = iconUrl
    ? L.icon({
        iconUrl: iconUrl,
        iconSize: [32, 32], // アイコンサイズ（必要に応じて調整可能）
        iconAnchor: [16, 32], // アンカーの位置（アイコンの底部中央を基準）
        popupAnchor: [0, -32] // ポップアップのアンカー位置
      })
    : null;

  try {
    const response = await fetch(`/stores/${placeId}`);
    if (!response.ok) {
      throw new Error(`店舗情報の取得に失敗しました: ${response.status}`);
    }

    const store = await response.json();

    const markerOptions = customIcon ? { icon: customIcon } : {};
    const popupId = `bookmark-btn-${store.id}`;
    const marker = L.marker([store.latitude, store.longitude], markerOptions)
      .addTo(map)
      .bindPopup(`
        <button class="bookmark-btn" id="${popupId}" data-store-id="${store.id}">★</button>
        <strong>${iconType} ${store.name}</strong><br>
        電話番号: ${store.phone_number || "電話番号不明"}<br>
        住所: ${store.address || "住所不明"}<br>
        ${store.web_site ? `<a href="${store.web_site}" target="_blank" rel="noopener noreferrer">公式サイト</a>` : "Webサイト不明"}
      `);
    marker.on("popupopen", function () {
      const btn = document.getElementById(popupId);
      if (btn) {
        btn.addEventListener("click", async function (e) {
          e.preventDefault();
          btn.disabled = true;
          btn.textContent = "★...";
          try {
            const res = await fetch(`/static_pages/${store.id}/bookmarks`, {
              method: "POST",
              headers: {
                "Content-Type": "application/json",
                "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
              }
            });
            if (res.ok) {
              btn.textContent = "★ブックマーク済";
              btn.disabled = true;
            } else if (res.status === 401) {
              btn.textContent = "ログイン必要";
              btn.disabled = false;
            } else {
              btn.textContent = "エラー";
              btn.disabled = false;
            }
          } catch (err) {
            btn.textContent = "通信エラー";
            btn.disabled = false;
          }
        });
      }
    });
    markerMap.set(store.id, marker);
  } catch (error) {
    console.error("情報ウィンドウの表示中にエラーが発生しました:", error.message);
  }
}

async function getAddress(lat, lon) {
  const apiKey = "bdc_cc1b9438aab142d78a5a257124d74595";
  const url = `https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${lat}&longitude=${lon}&localityLanguage=ja&key=${apiKey}`;
  let retryCount = 3;

  while (retryCount > 0) {
    try {
      const response = await fetch(url);

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const data = await response.json();

      console.log("BigDataCloud API Response:", data);
      const country = data.countryName || "";
      const subdivision = data.principalSubdivision || "";
      const locality = data.locality || "";
      const postcode = data.postcode || "";

      if (country || subdivision || locality || postcode) {
        return `${country} ${subdivision} ${locality} ${postcode}`.trim();
      } else {
        return "住所不明";
      }
    } catch (error) {
      console.error(`住所取得中にエラーが発生しました: ${error.message}`);
      retryCount -= 1;

      if (retryCount === 0) {
        return "住所取得エラー";
      }

      await new Promise(resolve => setTimeout(resolve, 1000));
    }
  }
}

// 店舗情報をサーバーに保存
async function saveStoreToDatabase(place) {
  const storeData = {
    store: {
      name: place.name,
      address: "住所取得中...",
      phone_number: place.tags.phone || "電話番号不明",
      web_site: place.tags.website || null,
      place_id: place.id,
      latitude: place.lat,
      longitude: place.lon
    }
  };

  try {
    const address = await getAddress(place.lat, place.lon);
    storeData.store.address = address;

    console.log("送信データ:", storeData);

    const response = await fetch("/create_store", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        // 必要に応じてCSRFトークンを追加
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").getAttribute("content")
      },
      body: JSON.stringify(storeData)
    });
    const data = await response.json();
    if (response.ok) {
      console.log("保存成功:", data.message);
    } else {
      console.error("保存に失敗しました:", data.errors);
    }
  } catch (error) {
    console.error("サーバーへの保存中にエラーが発生しました:", error.message);
  }
}

function setupCardClickEvents() {
  const cards = document.querySelectorAll(".card");
  console.log(`カードの数: ${cards.length}`);
  cards.forEach((card) => {
    const storeId = card.getAttribute("data-store-id"); // カードに設定された店舗IDを取得
    console.log(`カードのstoreId: ${storeId}`);
    card.addEventListener("click", () => {
      console.log(`カードがクリックされました: storeId = ${storeId}`);
      filterMarkers(storeId);
    });
  });

  const showAllButton = document.getElementById("show-all-markers");
  if (showAllButton) {
    showAllButton.addEventListener("click", () => {
      showAllMarkers();
    });
  }
}

function filterMarkers(storeId) {
  console.log(`フィルタリング対象のstoreId: ${storeId}`);
  markerMap.forEach((marker, id) => {
    if (id === parseInt(storeId, 10)) {
      marker.addTo(map); // 対象のマーカーを表示
      map.setView(marker.getLatLng(), 15);
    } else {
      map.removeLayer(marker); // 他のマーカーを非表示
    }
  });
  map.invalidateSize();
}

function showAllMarkers() {
  markerMap.forEach((marker) => {
    marker.addTo(map);
  });
}

document.addEventListener("turbo:load", () => {
  initMap();
});