/*************************************************************************
 *                                                                       *
 *  EJBCA: The OpenSource Certificate Authority                          *
 *                                                                       *
 *  This software is free software; you can redistribute it and/or       *
 *  modify it under the terms of the GNU Lesser General Public           *
 *  License as published by the Free Software Foundation; either         *
 *  version 2.1 of the License, or any later version.                    *
 *                                                                       *
 *  See terms of license at gnu.org.                                     *
 *                                                                       *
 *************************************************************************/
package org.ejbca.ui.cli.infrastructure.io;

import java.util.HashMap;
import java.util.Map;

/**
 * @version $Id: ValueFoundResponse.java 17685 2013-09-26 15:21:50Z samuellb $
 *
 */
public enum ValueFoundResponse {
    OVERWRITE("(O)verwrite", "o"), 
    SKIP("(S)kip", "s"), 
    OVERWRITE_ALL("Overwrite (A)ll", "a"), 
    SKIP_ALL(" Overwrite (N)one", "n");
    
    private static final Map<String, ValueFoundResponse> responseMap = new HashMap<String, ValueFoundResponse>();
    
    private final String text;
    private final String response;
    
    static {
        for(ValueFoundResponse valueFoundResponse : ValueFoundResponse.values()) {
           responseMap.put(valueFoundResponse.getResponse(), valueFoundResponse);
        }
    }
    
    private ValueFoundResponse(String text, String response) {
        this.text = text;
        this.response = response;
    }
    
    public static ValueFoundResponse getResponseFromInput(String input) {
        return responseMap.get(input.toLowerCase());
    }

    public String getResponse() {
        return response;
    }

    public String getText() {
        return text;
    }
    
    @Override
    public String toString() {
        return text;
    }
    
    public static String getQueryText() {
        return OVERWRITE + ", " + SKIP + ", " + OVERWRITE_ALL + ", " + SKIP_ALL + "?";
    }
    
    public boolean shouldOverWrite() {
        return this == OVERWRITE || this == OVERWRITE_ALL;
    }
}