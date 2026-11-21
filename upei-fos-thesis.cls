% upei-fos-thesis.cls - UPEI Faculty of Science MSc and PhD thesis class.
% Follows the Faculty of Science Thesis Formatting Guidelines (Graduate Studies Handbook).
% Compiles with pdfLaTeX, LuaLaTeX or XeLaTeX (e.g. latexmk -pdf thesis.tex).
%
% Class options
%   twoside   double-sided printing: 1.5in margin on the inside (left on odd pages,
%             right on even pages). Default is one-sided, 1.5in on the left.
%   arial     use Arial (or TeX Gyre Heros) instead of Times New Roman (or TeX Gyre Termes)
%   draft     standard LaTeX draft mode (marks overfull lines)
%
% Title page fields (in the preamble)
%   \title{...}  \author{...}  \degree{Master of Science} or \degree{Doctor of Philosophy}
%   \program{Environmental Sciences}   \academicunit{Department of Biology}
%   \thesisdate{April 2027}            \copyrightyear{2027}
%
% Preliminary pages (in this order, after \begin{document})
%   \maketitle  abstract  acknowledgments  \tableofcontents  \listoffigures
%   \listoftables  abbreviations  glossary  then \mainmatter before Chapter 1
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{upei-fos-thesis}[2026/11/21 v1.0 UPEI Faculty of Science thesis]

\newif\ifut@twoside
\newif\ifut@arial
\DeclareOption{twoside}{\ut@twosidetrue\PassOptionsToClass{twoside}{report}}
\DeclareOption{oneside}{\ut@twosidefalse\PassOptionsToClass{oneside}{report}}
\DeclareOption{arial}{\ut@arialtrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ExecuteOptions{oneside}
\ProcessOptions\relax
\LoadClass[12pt,letterpaper,openany]{report}

\RequirePackage{iftex}

% --- Page: letter size; 1.5in binding margin, 1in on the other sides -------------
\ifut@twoside
  \RequirePackage[letterpaper, inner=1.5in, outer=1in, top=1in, bottom=1in,
    footskip=0.5in]{geometry}
\else
  \RequirePackage[letterpaper, left=1.5in, right=1in, top=1in, bottom=1in,
    footskip=0.5in]{geometry}
\fi

% --- One typeface, 12pt ----------------------------------------------------------
\RequirePackage{amsmath}
\ifPDFTeX
  % pdfLaTeX (or latex -> dvips): Type 1 Times / Helvetica clones that ship with
  % both TeX Live (macOS, Linux) and MiKTeX (Windows).
  \RequirePackage[T1]{fontenc}
  \RequirePackage[utf8]{inputenc}
  \ifut@arial
    \RequirePackage[scaled=1]{helvet}
    \renewcommand\familydefault{\sfdefault}
    \renewcommand\rmdefault{\sfdefault}% one typeface, even where \rmfamily is used
    \RequirePackage{newtxmath}
  \else
    \RequirePackage{newtxtext}
    \renewcommand\sfdefault{\rmdefault}% one typeface, even where \sffamily is used
    \RequirePackage{newtxmath}
  \fi
\else
  % LuaLaTeX or XeLaTeX: system or TeX Gyre OpenType fonts.
  \RequirePackage{fontspec}
  \RequirePackage{unicode-math}
  \ifut@arial
    \IfFontExistsTF{Arial}{\def\ut@font{Arial}}{\def\ut@font{TeX Gyre Heros}}
  \else
    \IfFontExistsTF{Times New Roman}{\def\ut@font{Times New Roman}}{\def\ut@font{TeX Gyre Termes}}
  \fi
  \setmainfont{\ut@font}
  \setsansfont{\ut@font}% one typeface, even where \sffamily is used
  \IfFontExistsTF{TeX Gyre Termes Math}
    {\setmathfont{TeX Gyre Termes Math}}
    {\setmathfont{Latin Modern Math}}
\fi

% --- Spacing: double-spaced body; single-spaced footnotes, captions, references --
\RequirePackage[doublespacing]{setspace}
\RequirePackage{etoolbox}
\RequirePackage{ragged2e}
\AtBeginDocument{\RaggedRight}           % left-justified (ragged right), with hyphenation
\setlength{\RaggedRightParindent}{0.5in}
\setlength{\parindent}{0.5in}
\clubpenalty=10000 \widowpenalty=10000   % no single lines stranded at a page break
\raggedbottom

% --- Headings: same typeface, bold; kept with at least two lines of text ---------
\RequirePackage{titlesec}
\titleformat{\chapter}[display]{\normalfont\bfseries\singlespacing}
  {\chaptertitlename\ \thechapter}{0pt}{}
\titleformat{name=\chapter, numberless}[block]{\normalfont\bfseries\singlespacing}{}{0pt}{}
\titlespacing*{\chapter}{0pt}{0pt}{24pt}
\titleformat{\section}{\normalfont\bfseries}{\thesection}{1em}{}
\titleformat{\subsection}{\normalfont\bfseries}{\thesubsection}{1em}{}
\titleformat{\subsubsection}{\normalfont\bfseries\itshape}{\thesubsubsection}{1em}{}
\titlespacing*{\section}{0pt}{12pt}{0pt}
\titlespacing*{\subsection}{0pt}{12pt}{0pt}
\titlespacing*{\subsubsection}{0pt}{12pt}{0pt}
\RequirePackage{needspace}
% A heading needs room for itself plus two lines of text, or it moves to the next page.
\preto\section{\Needspace{4\baselineskip}}
\preto\subsection{\Needspace{4\baselineskip}}
\preto\subsubsection{\Needspace{4\baselineskip}}

\def\ut@tablename{table}
% --- Captions: tables above, figures below; not centred, not indented, single-spaced
\RequirePackage{caption}
\captionsetup{font={singlespacing}, labelfont=bf, labelsep=period,
  justification=raggedright, singlelinecheck=false, skip=6pt}
\captionsetup[table]{position=above}
\captionsetup[figure]{position=below}
% Tables are centred on the page under their (left-aligned) caption.
\g@addto@macro\@floatboxreset{\ifx\@captype\ut@tablename\centering\fi}
% With tagging on (\DocumentMetadata{... tagging=on}), the LaTeX kernel replaces
% \@makecaption at \begin{document}, which discards the caption package settings
% above. Put the same layout back, keeping the kernel's tagging sockets.
\long\def\ut@makecaption#1#2{%
  \UseHookWithArguments{cmd/@makecaption/before}{2}{#1}{#2}%
  \ifx\@captype\ut@tablename\else\vskip 6pt\fi
  \UseTaggingSocket{caption/begin}{\@current@float@struct}%
  \begingroup
    \normalfont\normalsize\singlespacing
    \RaggedRight\parindent\z@
    \UseTaggingSocket{caption/label/begin}%
    \UseSocket{caption/label}{#1}%
    \UseTaggingSocket{caption/label/end}%
    \UseTaggingSocket{para/begin}%
    #2\par
  \endgroup
  \UseTaggingSocket{caption/end}%
  \ifx\@captype\ut@tablename\vskip 6pt\fi}
\def\ut@captionlabel#1{\textbf{#1.}\ }
\AddToHook{begindocument/end}{%
  \@ifpackageloaded{latex-lab-testphase-float}{%
    \NewSocketPlug{caption/label}{upei}{\ut@captionlabel{#1}}%
    \AssignSocketPlug{caption/label}{upei}%
    \let\@makecaption\ut@makecaption
  }{}}

% --- Equations numbered consecutively through the thesis -------------------------
\counterwithout{equation}{chapter}

% --- Footnotes single-spaced (setspace does this), references single-spaced -------
\AtBeginEnvironment{thebibliography}{\singlespacing\setlength{\itemsep}{12pt}}

% --- Contents lists: preliminary pages listed, dot leaders ------------------------
\RequirePackage{tocloft}
\renewcommand{\cftchapleader}{\cftdotfill{\cftdotsep}}
\renewcommand{\cftchapfont}{\normalfont}
\renewcommand{\cftchappagefont}{\normalfont}
\setlength{\cftbeforechapskip}{6pt}

% --- Title page fields ------------------------------------------------------------
\newcommand\degree[1]{\def\ut@degree{#1}}
\newcommand\program[1]{\def\ut@program{#1}}
\newcommand\academicunit[1]{\def\ut@unit{#1}}
\newcommand\thesisdate[1]{\def\ut@date{#1}}
\newcommand\copyrightyear[1]{\def\ut@year{#1}}
\def\ut@degree{[Master of Science or Doctor of Philosophy]}
\def\ut@program{[Program name]}
\def\ut@unit{[Academic unit]}
\def\ut@date{\today}
\def\ut@year{\the\year}

% Title page: page i, number not shown; everything centred.
\renewcommand\maketitle{%
  \pagenumbering{roman}%
  \begin{titlepage}
    \setcounter{page}{1}%
    \centering\singlespacing
    \vspace*{0.5in}
    {\bfseries\@title\par}
    \vspace{0.6in}
    A thesis submitted in partial fulfilment of the requirements\\
    for the degree of\par
    \vspace{12pt}
    \ut@degree\\
    in \ut@program\par
    \vspace{0.5in}
    \ut@unit\\
    Faculty of Science\par
    \vspace{0.5in}
    \@author\par
    \vspace{12pt}
    University of Prince Edward Island\par
    \vspace{12pt}
    \ut@date\par
    \vfill
    \copyright\ \ut@year, \@author\par
  \end{titlepage}%
  \setcounter{page}{2}}

% --- Unnumbered preliminary chapters that appear in the table of contents ----------
\newcommand\ut@prelim[1]{%
  \chapter*{#1}\addcontentsline{toc}{chapter}{#1}}
\renewenvironment{abstract}{\ut@prelim{Abstract}}{\clearpage}
\newenvironment{acknowledgments}{\ut@prelim{Acknowledgments}}{\clearpage}
\renewcommand\contentsname{Table of Contents}
\renewcommand\cftloftitlefont{\normalfont\bfseries}
\renewcommand\cftlottitlefont{\normalfont\bfseries}
\renewcommand\cfttoctitlefont{\normalfont\bfseries}
\renewcommand\cftaftertoctitle{\par}
\renewcommand\cftafterloftitle{\par}
\renewcommand\cftafterlottitle{\par}
\setlength{\cftbeforetoctitleskip}{0pt}
\setlength{\cftbeforeloftitleskip}{0pt}
\setlength{\cftbeforelottitleskip}{0pt}
% Each list starts on a new page and is listed in the table of contents. The lists
% are set justified so the dot leaders line up.
\AddToHook{begindocument/end}{%
  \let\ut@oldtoc\tableofcontents
  \let\ut@oldlof\listoffigures
  \let\ut@oldlot\listoftables
  \renewcommand\tableofcontents{\clearpage{\justifying\ut@oldtoc}\clearpage}%
  \renewcommand\listoffigures{\clearpage\phantomsection
    \addcontentsline{toc}{chapter}{\listfigurename}{\justifying\ut@oldlof}\clearpage}%
  \renewcommand\listoftables{\clearpage\phantomsection
    \addcontentsline{toc}{chapter}{\listtablename}{\justifying\ut@oldlot}\clearpage}}

% List of abbreviations and glossary: two-column lists, single-spaced.
%   \begin{abbreviations} \abbrev{ESC}{Environmental Sciences} ... \end{abbreviations}
\newcommand\abbrev[2]{\item[#1] #2}
\newenvironment{abbreviations}
  {\ut@prelim{List of Abbreviations}\singlespacing
   \begin{list}{}{\setlength{\labelwidth}{1.25in}\setlength{\leftmargin}{1.5in}
     \setlength{\labelsep}{0.25in}\setlength{\itemsep}{6pt}
     \renewcommand\makelabel[1]{##1\hfil}}}
  {\end{list}\clearpage}
\newenvironment{glossaryterms}
  {\ut@prelim{Glossary}\singlespacing
   \begin{description}\setlength{\itemsep}{6pt}}
  {\end{description}\clearpage}

% --- Main body: Arabic numbers from Chapter 1 -------------------------------------
\newcommand\mainmatter{\clearpage\pagenumbering{arabic}}

% --- Appendices: \appendix, then \chapter{...} for each. They continue the page
% numbering of the main body and are listed in the table of contents. Appendices may
% be single-spaced: add \singlespacing after \appendix if you want that.

% --- Links and PDF metadata --------------------------------------------------------
\RequirePackage{graphicx}
\RequirePackage{booktabs}
\RequirePackage[hidelinks]{hyperref}
\pagestyle{plain}  % page number centred at the bottom
