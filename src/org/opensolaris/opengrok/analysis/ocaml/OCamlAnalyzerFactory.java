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
 * Copyright (c) 2007, 2010, Oracle and/or its affiliates. All rights reserved.
 */

package org.opensolaris.opengrok.analysis.ocaml;

import java.io.IOException;
import java.io.Reader;
import java.io.Writer;
import org.opensolaris.opengrok.analysis.Definitions;
import org.opensolaris.opengrok.analysis.FileAnalyzer;
import org.opensolaris.opengrok.analysis.FileAnalyzer.Genre;
import org.opensolaris.opengrok.analysis.FileAnalyzerFactory;
import org.opensolaris.opengrok.configuration.Project;
import org.opensolaris.opengrok.history.Annotation;

public class OCamlAnalyzerFactory extends FileAnalyzerFactory {
    private static final String[] SUFFIXES = {
        "ML",
        "MLI",
    };
    /* If someone adds an analyzer for another dialect of ML (say, SML-NJ), this will cause trouble.
       (See the commented out "PM" extension in Python analyzer).
       Perhaps a better way to design the matching up of analyzers to files would be to have
       the analyzer report what language it supports, and then have something like
       "list of suffixes to list of analyzers, in priority order" as a [per-project] user option.*/

    public OCamlAnalyzerFactory() {
        super(null, SUFFIXES, null, null, "text/plain", Genre.PLAIN);
    }

    @Override
    protected FileAnalyzer newAnalyzer() {
        return new OCamlAnalyzer(this);
    }

    @Override
    public void writeXref(Reader in, Writer out, Definitions defs, Annotation annotation, Project project)
        throws IOException {
        OCamlAnalyzer.writeXref(in, out, defs, annotation, project);
    }
}
