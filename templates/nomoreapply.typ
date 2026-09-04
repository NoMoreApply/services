// nomoreapply.typ: Pandoc/Typst template for NoMoreApply brochures
// Modes: individual (full profile) | team (member cards)
// Controlled by Pandoc boolean variables: individual:true | team:true
//
// Token table is documented in CLAUDE.md; keep both in sync.

#let bg          = rgb("#FAFAFA")   // off-white page background
#let nearblack   = rgb("#09090B")   // primary text / dark band background
#let red         = rgb("#DC143C")   // NMA brand red (matches live nomoreapply.com)
#let midgrey     = rgb("#71717A")   // secondary / muted text
#let darkgrey    = rgb("#52525B")   // text secondary (denser than midgrey)
#let faintgrey   = rgb("#A1A1AA")   // eyebrow / faint text on dark bands
#let lightgrey   = rgb("#E4E4E7")   // dividers and card borders
#let offwhite    = rgb("#FAFAFA")   // text on dark bands

// Pandoc renders substituted metadata as Typst content (it may contain markdown
// constructs like #emph, #cite, or escaped characters), never as a plain string.
// Interpolating it inside "..." breaks the moment a value has a quote, @mention,
// or markdown syntax. Always interpolate metadata as a content block: [...].
#let doc_name = [$name$$if(team_name)$$team_name$$endif$]

#set page(
  paper: "a4",
  margin: (left: 22mm, right: 22mm, top: 18mm, bottom: 22mm),
  fill: bg,
  header: context {
    if counter(page).get().first() > 1 {
      grid(
        columns: (1fr, auto),
        text(size: 8pt, fill: midgrey, weight: "semibold")[#doc_name],
        text(size: 8pt, fill: midgrey)[
          #counter(page).display("1 / 1", both: true)
        ]
      )
      v(0.2em)
      line(length: 100%, stroke: 0.4pt + lightgrey)
    }
  },
  footer: align(center)[
    #text(size: 7.5pt, fill: midgrey)[NoMoreApply | nomoreapply.com]
  ]
)

#set text(font: "Inter", size: 10pt, fill: nearblack)
#set par(leading: 0.75em, spacing: 0.75em)

// Section heading: accent bar above, small bold uppercase eyebrow label.
// block(sticky: true) keeps the heading glued to what follows so it can't
// strand alone at a page bottom (Typst's default heading behavior, which the
// text()+v() shape above would otherwise discard).
#show heading.where(level: 2): it => block(sticky: true, below: 0pt)[
  #v(0.9em, weak: true)
  #rect(width: 14pt, height: 2pt, fill: red)
  #v(0.2em)
  #text(size: 7.5pt, fill: faintgrey, weight: "bold", tracking: 0.12em)[
    #upper(it.body)
  ]
  #v(0.3em)
]

// Work-entry heading: bold company/project name, glued to its meta line/body
#show heading.where(level: 3): it => block(sticky: true, below: 0pt)[
  #v(0.4em)
  #text(size: 10.5pt, weight: "bold")[#it.body]
  #v(0.05em)
]

// Meta line under a level-3 heading, written as *italic* in source markdown
#show emph: set text(fill: darkgrey, size: 9pt, style: "normal")

// Coherent list spacing: one rule, no contradiction between par and list settings
#set list(indent: 1em, spacing: 0.4em)
#show list: set par(leading: 0.65em, spacing: 0.4em)

// Member card: subtle left border (team mode). breakable: false keeps the
// whole card, and its left accent rule, on one page.
#let accentcard(body) = block(
  width: 100%,
  breakable: false,
  inset: (left: 12pt, top: 6pt, bottom: 6pt, right: 0pt),
  stroke: (left: 2pt + lightgrey),
  spacing: 0.8em,
  body
)

// Proof band: a row of stat cells with a muted rule above and below.
// "medium" (500) isn't in templates/fonts/ (only 400/600/700), so Typst
// silently substitutes the nearest weight - keep it at the default weight.
#let proofband(items) = block(width: 100%, above: 0.6em, below: 0.6em)[
  #line(length: 100%, stroke: 0.5pt + lightgrey)
  #v(0.5em)
  #grid(
    columns: (1fr,) * items.len(),
    column-gutter: 10pt,
    ..items.map(it => text(size: 8.5pt, fill: darkgrey)[#it])
  )
  #v(0.5em)
  #line(length: 100%, stroke: 0.5pt + lightgrey)
]

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

$if(proof)$
#proofband(($for(proof)$[$proof$],$endfor$))
$else$
#v(0.3em)
#line(length: 100%, stroke: 0.5pt + lightgrey)
#v(0.4em)
$endif$

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

#v(0.6em)
#block(width: 100%, fill: nearblack, inset: (x: 18pt, y: 14pt), radius: 3pt)[
  #align(center)[#text(size: 10pt, weight: "semibold", fill: offwhite)[$cta$]]
]

$endif$
$endif$
