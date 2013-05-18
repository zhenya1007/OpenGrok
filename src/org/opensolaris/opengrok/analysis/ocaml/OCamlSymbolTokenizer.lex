/*
 * CDDL HEADER START
 *
 * The contents of this file are subject to the terms of the
 * Common Development and Distribution License (the "License").
 * You may not use this file except in compliance with the License.
 *
 * See LICENSE.txt included in this distribution for the specific
 * language governing permissions and limitations under the License.
 *
 * When distributing Covered Code, include this CDDL HEADER in each
 * file and include the License file at LICENSE.txt.
 * If applicable, add the following below this CDDL HEADER, with the
 * fields enclosed by brackets "[]" replaced with your own identifying
 * information: Portions Copyright [yyyy] [name of copyright owner]
 *
 * CDDL HEADER END
 */

/*
 * Copyright (c) 2006, 2010, Oracle and/or its affiliates. All rights reserved.
 */

/*
 * Gets OCaml symbols - ignores comments, strings, keywords
 */

package org.opensolaris.opengrok.analysis.ocaml;
import java.io.IOException;
import java.io.Reader;
import org.opensolaris.opengrok.analysis.JFlexTokenizer;

%%
%public
%class OCamlSymbolTokenizer
%extends JFlexTokenizer
%unicode
%init{
super(in);
%init}
%type boolean
%eofval{
return false;
%eofval}
%char

%{
    private int nestedComment;
%}

Identifier = [A-Za-z_\u00c0-\u00d6\u00d8-\u00f6\u00f8-\u00ff\'0-9]+

%state STRING COMMENT QSTRING

%%

<YYINITIAL> {
{Identifier} {String id = yytext();
              if (!Consts.kwd.contains(id.toLowerCase())) {
                        setAttribs(id, yychar, yychar + yylength());
                        return true; }
              }
 \"     { yybegin(STRING); }
 \'     { yybegin(QSTRING); }
}

<STRING> {
 \"     { yybegin(YYINITIAL); }
\\\\ | \\\"     {}
}

<QSTRING> {
 \'     { yybegin(YYINITIAL); }
 \\\\ | \\\'     {}
}

<YYINITIAL, COMMENT> {
 "(*"    { yybegin(COMMENT); ++nestedComment; }
}

<COMMENT> {
"*)"    { if (--nestedComment == 0) { yybegin(YYINITIAL); } }
}

<YYINITIAL, STRING, COMMENT, QSTRING> {
<<EOF>>   { return false;}
.|\n    {}
}
