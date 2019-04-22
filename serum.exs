%{
  site_name: "wevtimoteo",
  site_description: "kairos _ sharing _ tech _ learning _ kaizen _ path",
  date_format: "{WDfull}, {D} {Mshort} {YYYY}",
  base_url: "/",
  server_root: "https://wevtimoteo.github.io",
  author: "Weverton Timoteo",
  author_email: "weverton.ct@gmail.com",
  list_title_all: "Posts",
  list_title_tag: "Posts Tagged \"~s\"",
  pagination: true,
  posts_per_page: 10,
  preview_length: 0,
  plugins: [
    {Serum.Plugins.LiveReloader, only: :dev}
  ]
}
