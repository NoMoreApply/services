// wandercode.typ: Pandoc/Typst template for NoMoreApply brochures
// Modes: individual (full profile) | team (member cards)
// Controlled by $documenttype$ Pandoc variable

#let cream = rgb("#F5F4EF")
#let nearblack = rgb("#1A1A2E")
#let teal = rgb("#A0303A")
#let midgrey = rgb("#666677")

#set page(
  paper: "a4",
  margin: (left: 25mm, right: 25mm, top: 20mm, bottom: 25mm),
  fill: cream,
  footer: align(center)[
    #text(size: 8pt, fill: midgrey)[NoMoreApply | nomoreapply.com]
  ]
)

#set text(font: "Inter", size: 10.5pt, fill: nearblack)
#set par(leading: 0.8em, spacing: 0.6em)

// Section heading style
#show heading.where(level: 2): it => {
  v(0.8em)
  text(size: 9pt, fill: nearblack, weight: "semibold", tracking: 0.08em)[
    #upper(it.body)
  ]
  line(length: 100%, stroke: 0.6pt + teal)
  v(0.2em)
}

#show heading.where(level: 3): it => {
  v(0.4em)
  text(weight: "semibold")[#it.body]
  v(0.1em)
}

// Bullet list
#set list(indent: 1em, spacing: 0.2em)

// Member card with teal left border (team mode)
#let accentcard(body) = block(
  width: 100%,
  inset: (left: 12pt, top: 6pt, bottom: 6pt, right: 0pt),
  stroke: (left: 3pt + teal),
  spacing: 0.8em,
  body
)

$if(individual)$
// ── INDIVIDUAL PROFILE ──────────────────────────────────────────────────────

#text(size: 22pt, weight: "bold")[$name$]
#v(0.1em)
#text(size: 13pt, fill: teal)[$role$]
#v(0.05em)
#text(size: 10pt, fill: midgrey, style: "italic")[$tagline$]

#v(0.5em)

// Contact line
#text(size: 9pt, fill: midgrey)[
  $if(location)$$location$$endif$
  $if(email)$ · #link("mailto:$email$")[$email$]$endif$
  $if(linkedin)$ · #link("$linkedin$")[LinkedIn]$endif$
  $if(github)$ · #link("$github$")[GitHub]$endif$
  $if(website)$ · #link("$website$")[$website$]$endif$
]

#v(0.3em)
#line(length: 100%, stroke: 0.6pt + teal)
#v(0.4em)

$body$

$else$
$if(team)$
// ── TEAM BROCHURE ───────────────────────────────────────────────────────────

#align(center)[
  #text(size: 24pt, weight: "bold")[$team_name$]
  #v(0.2em)
  #text(size: 14pt, fill: teal)[$team_tagline$]
  #v(0.3em)
  #line(length: 50%, stroke: 0.6pt + teal)
  #v(0.4em)
  #text(size: 10.5pt)[$team_description$]
]

#v(0.6em)

$body$

#v(0.8em)
#align(center)[
  #line(length: 40%, stroke: 0.4pt + teal)
  #v(0.2em)
  #text(size: 9pt, weight: "semibold")[$cta$]
]

$endif$
$endif$
