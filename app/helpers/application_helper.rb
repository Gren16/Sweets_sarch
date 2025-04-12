module ApplicationHelper
  def default_meta_tags
    {
      site: "sweets_sarch",
      title: "現在地周辺のスイーツ店を地図上に表示させるサービス",
      reverse: true,
      charset: "utf-8",
      description: "sweets_sarchでは、周辺のスイーツ店を表示させ気に入ったお店をブックマークすることができ、ルートを作成することができます。",
      keywords: "菓子,スイーツ,和菓子,ルート",
      canonical: "sweets-sarch.net",
      separator: "|",
      og: {
        site_name: "sweets_sarch",
        title: "現在地周辺のスイーツ店を地図上に表示させるサービス",
        description: "sweets_sarchでは、周辺のスイーツ店を表示させ気に入ったお店をブックマークすることができ、ルートを作成することができます。", # 修正：文字列を使用
        type: "website",
        url: "sweets-sarch.net",
        image: image_url("ogp.png"),
        locale: "ja-JP"
      },
      twitter: {
        card: "summary_large_image",
        site: "@COAT__",
        image: image_url("ogp.png")
      }
    }
  end
end
