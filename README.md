# Using the UPEI Faculty of Science Thesis Class

This template is set up to meet the Faculty of Science Thesis Formatting Guidelines. The class file, `upei-fos-thesis.cls`, handles the margins, spacing, typeface, page numbering, heading numbering, table of contents and lists of figures and tables for you. Write your thesis in `thesis.tex` (or another file with the same header information) and your references in `references.bib`.

Replace the text in the sample chapters with your own, and delete any sections you don't need.

**Building your thesis**

- The template builds with **pdfLaTeX** by default. From the template folder, run `latexmk thesis.tex`. The included `latexmkrc` file tells latexmk to use pdfLaTeX, and latexmk runs LaTeX and BibTeX as many times as needed.
- **LuaLaTeX** gives the most complete tagging for an accessible PDF, so use it for your final version if you can: `latexmk -lualatex thesis.tex`. XeLaTeX also works: `latexmk -xelatex thesis.tex`.
- Without latexmk, run `pdflatex thesis`, then `bibtex thesis`, then `pdflatex thesis` twice more.
- The first line of `thesis.tex`, `% !TEX program = pdflatex`, tells editors such as TeXShop, TeXworks and TeXstudio which engine to use. Change it to `lualatex` if you switch engines.
- On Overleaf, open Menu and set TeX Live version to **2025 or later**. Compiler can stay at **pdfLaTeX**, or set it to **LuaLaTeX** for the final version.
- The template works with TeX Live (macOS, Linux) and MiKTeX (Windows).
- The `\DocumentMetadata{...}` line near the top of `thesis.tex` makes your PDF accessible (tagged). It needs a TeX distribution from 2025 or later. If your TeX is older and the build fails, put a `%` in front of that line to build drafts, but build the final version on a current TeX.
- Building creates helper files next to `thesis.tex` (`.aux`, `.toc`, `.bbl`, `.log` and others). Run `latexmk -c` to delete most of them and keep the PDF. It leaves `thesis.bbl`, which is safe to delete by hand, as is `thesis-luamml-mathml.html`, a copy of your equations that LuaLaTeX writes for tagging.

**Setting up the document**

- **Class options:** `\documentclass{upei-fos-thesis}` gives one-sided printing in Times. Add options as needed: `\documentclass[twoside]{upei-fos-thesis}` for double-sided printing with mirrored margins, `[arial]` for Arial, or `[draft]` to mark lines that run into the margin. You can combine them: `[twoside,arial]`.
- **Fonts:** with pdfLaTeX, the template uses close copies of Times and Arial that come with every TeX distribution. With LuaLaTeX or XeLaTeX, it uses Times New Roman or Arial if they are installed on your computer, and otherwise TeX Gyre Termes or TeX Gyre Heros, which look the same.
- **Title page:** fill in `\title`, `\author`, `\degree` (Master of Science or Doctor of Philosophy), `\program`, `\academicunit`, `\thesisdate` and `\copyrightyear` in the preamble. `\maketitle` lays out the title page for you.
- **PDF properties:** put the same title and name in `\hypersetup{pdftitle={...}, pdfauthor={...}}`. Screen readers and PDF viewers show these.

**Which command to use**

*Preliminary pages (in this order, before `\mainmatter`)*
- `\maketitle`: the title page, counted as page i, with its number hidden.
- `\begin{abstract} ... \end{abstract}`: the Abstract.
- `\begin{acknowledgments} ... \end{acknowledgments}`: the Acknowledgments.
- `\tableofcontents`, `\listoffigures`, `\listoftables`: these lists are built automatically. Each starts on a new page and appears in the table of contents.
- `\begin{abbreviations} \abbrev{ESC}{Environmental Sciences} ... \end{abbreviations}`: the List of Abbreviations, one `\abbrev` per entry.
- `\begin{glossaryterms} \item[Term] Definition ... \end{glossaryterms}`: the Glossary.

*Main body*
- `\mainmatter`: put this just before Chapter 1. Page numbering switches to 1, 2, 3 from there.
- `\chapter{Title}`: chapter titles. LaTeX adds "Chapter 1", "Chapter 2" and so on above the title automatically, so type only the title, such as `\chapter{Introduction}`.
- `\section{Title}`: sections within a chapter, numbered automatically (1.1, 1.2).
- `\subsection{Title}`: subsections, numbered automatically (1.1.1).
- `\subsubsection{Title}`: a fourth level, if you need one (1.1.1.1). Avoid going deeper than this.

Never type a heading's number yourself. If you add, move or delete a section, LaTeX renumbers everything when you rebuild.

*Back matter*
- **Literature Cited:** this comes from `\bibliography{references}` at the end of the main body. The template already gives it an unnumbered heading and adds it to the table of contents.
- **Appendices:** put `\appendix` once after the Literature Cited, then start each appendix with `\chapter{Title}`. They are lettered automatically ("Appendix A", then B, C), continue the page numbering and appear in the table of contents. They may be single-spaced: add `\singlespacing` after `\appendix` if you want that.
- `\chapter*{Title}`: any other unnumbered heading. To list it in the table of contents, follow it with `\addcontentsline{toc}{chapter}{Title}`.

*Citations and references*
- Cite with `\citep{key}` for "(Smith and Chen 2020)" and `\citet{key}` for "Smith and Chen (2020)".
- Choose your discipline's style with `\bibliographystyle{...}`. The comments in `thesis.tex` list common choices: plainnat (author-year), ieeetr (IEEE), achemso (ACS), amsplain (AMS) and ACM-Reference-Format (ACM). For numbered citations, change `\usepackage{natbib}` to `\usepackage[numbers]{natbib}`.
- Reference managers such as Zotero and Mendeley can export a `.bib` file for you. Check every entry against the original source.

*Tables and figures*
- **Tables:** put `\caption{...}` before the `tabular` so the caption sits above the table. Use `\toprule`, `\midrule` and `\bottomrule` for rules, and no vertical lines.
- **Figures:** put `\caption{...}` after `\includegraphics` so the caption sits below the figure. Describe every figure for screen readers with `alt`, for example `\includegraphics[width=\linewidth, alt={Bar chart showing biomass is higher at the north site}]{figure1}`.
- Give each table and figure a `\label{...}` after its caption, and refer to it with `Table~\ref{...}` or `Figure~\ref{...}` so the numbers stay correct.

*Equations*
- Use `\begin{equation} ... \end{equation}`. Equations are numbered consecutively through the thesis, and you can refer to them with `\label` and `\eqref`.

**Keeping things up to date**

The table of contents, lists, cross-references and citations update every time you build, but they can lag one build behind. `latexmk` and Overleaf both rerun until everything is current. If you see `??` in the PDF, a `\ref` or `\cite` key doesn't match a label or a `.bib` entry. Check the spelling of the key.
