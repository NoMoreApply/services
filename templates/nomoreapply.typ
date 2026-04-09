// nomoreapply.typ: Pandoc/Typst template for NoMoreApply brochures
// Modes: individual (full profile) | team (member cards)
// Controlled by Pandoc boolean variables: individual:true | team:true

#let bg        = rgb("#FAFAFA")   // off-white page background
#let nearblack = rgb("#09090B")   // primary text
#let red       = rgb("#e8002d")   // NMA brand red
#let midgrey   = rgb("#71717A")   // secondary / muted text
#let lightgrey = rgb("#E4E4E7")   // dividers and card borders

#set page(
  paper: "a4",
  margin: (left: 22mm, right: 22mm, top: 18mm, bottom: 22mm),
  fill: bg,
  footer: align(center)[
    #text(size: 7.5pt, fill: midgrey)[NoMoreApply | nomoreapply.com]
  ]
)

#set text(font: "Inter", size: 10pt, fill: nearblack)
#set par(leading: 0.75em, spacing: 0.5em)

// Section heading: small, bold, uppercase, subtle grey rule
#show heading.where(level: 2): it => {
  v(0.7em)
  text(size: 7.5pt, fill: nearblack, weight: "bold", tracking: 0.1em)[
    #upper(it.body)
  ]
  v(0.15em)
  line(length: 100%, stroke: 0.5pt + lightgrey)
  v(0.25em)
}

#show heading.where(level: 3): it => {
  v(0.35em)
  text(size: 10pt, weight: "semibold")[#it.body]
  v(0.1em)
}

#set list(indent: 1em, spacing: 0.2em)
// Prevent par spacing from creating extra gaps inside wrapped list items
#show list: set par(leading: 0.65em, spacing: 0em)

// Member card: subtle left border (team mode)
#let accentcard(body) = block(
  width: 100%,
  inset: (left: 12pt, top: 6pt, bottom: 6pt, right: 0pt),
  stroke: (left: 2pt + lightgrey),
  spacing: 0.8em,
  body
)

$if(individual)$
// INDIVIDUAL PROFILE

#text(size: 26pt, weight: "bold", tracking: -0.02em)[$name$]
#v(0.1em)
#text(size: 12pt, fill: red, weight: "semibold")[$role$]
#v(0.05em)
#text(size: 10pt, fill: midgrey, style: "italic")[$tagline$]

#v(0.45em)
#text(size: 8.5pt, fill: midgrey)[
  $if(location)$$location$$endif$
  $if(email)$ · #link("mailto:$email$")[$email$]$endif$
  $if(linkedin)$ · #link("$linkedin$")[LinkedIn]$endif$
  $if(github)$ · #link("$github$")[GitHub]$endif$
  $if(website)$ · #link("$website$")[$website$]$endif$
]
#v(0.3em)
#line(length: 100%, stroke: 0.5pt + lightgrey)
#v(0.4em)

$body$

$else$
$if(team)$
// TEAM BROCHURE

#align(center)[
  #text(size: 24pt, weight: "bold", tracking: -0.02em)[$team_name$]
  #v(0.2em)
  #text(size: 13pt, fill: red, weight: "semibold")[$team_tagline$]
  #v(0.3em)
  #line(length: 50%, stroke: 0.5pt + lightgrey)
  #v(0.4em)
  #text(size: 10pt, fill: midgrey)[$team_description$]
]

#v(0.6em)

$body$

#v(0.8em)
#align(center)[
  #line(length: 40%, stroke: 0.4pt + lightgrey)
  #v(0.2em)
  #text(size: 9pt, weight: "semibold", fill: nearblack)[$cta$]
]

$endif$
$endif$
