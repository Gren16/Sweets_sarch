import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="autocomplete"
export default class extends Controller {
  static values = { url: String }
  static targets = ["results"]

  search(event) {
    const query = event.target.value.trim();

    if (query.length === 0) {
      this.clearResults();
      return;
    }

    const url = `${this.urlValue}?q[name_or_address_cont]=${encodeURIComponent(query)}`;

    fetch(url)
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
      })
      .then(data => this.updateResults(data))
      .catch(error => {
        console.error("Error fetching autocomplete data:", error);
        this.resultsTarget.innerHTML = `<li class="list-group-item text-danger">エラーが発生しました</li>`;
      });
  }

  updateResults(data) {
    this.resultsTarget.innerHTML = '';

    data.forEach(item => {
      const li = document.createElement("li");
      li.textContent = `${item.name} (${item.address})`;
      li.classList.add("list-group-item", "list-group-item-action");
      li.addEventListener("click", () => {
        this.selectResult(item);
      });
      this.resultsTarget.appendChild(li);
    });
  }

  selectResult(item) {
    const input = this.element.querySelector("input");
    input.value = item.name; // 選択された値を入力フィールドにセット
    this.clearResults();
  }

  clearResults() {
    this.resultsTarget.innerHTML = "";
  }
}
