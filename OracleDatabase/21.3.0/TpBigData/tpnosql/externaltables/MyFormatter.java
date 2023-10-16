/*-
 *
 *  This file is part of Oracle NoSQL Database
 *  Copyright (C) 2011, 2013 Oracle and/or its affiliates.  All rights reserved.
 *
 *  Oracle NoSQL Database is free software: you can redistribute it and/or
 *  modify it under the terms of the GNU Affero General Public License
 *  as published by the Free Software Foundation, version 3.
 *
 *  Oracle NoSQL Database is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public
 *  License in the LICENSE file along with Oracle NoSQL Database.  If not,
 *  see <http://www.gnu.org/licenses/>.
 *
 *  An active Oracle commercial licensing agreement for this product
 *  supercedes this license.
 *
 *  For more information please contact:
 *
 *  Vice President Legal, Development
 *  Oracle America, Inc.
 *  5OP-10
 *  500 Oracle Parkway
 *  Redwood Shores, CA 94065
 *
 *  or
 *
 *  berkeleydb-info_us@oracle.com
 *
 *  [This line intentionally left blank.]
 *  [This line intentionally left blank.]
 *  [This line intentionally left blank.]
 *  [This line intentionally left blank.]
 *  [This line intentionally left blank.]
 *  [This line intentionally left blank.]
 *  EOF
 *
 */

package externaltables;

import java.io.ByteArrayInputStream;
import java.io.DataInput;
import java.io.DataInputStream;
import java.io.IOException;
import java.util.List;

import oracle.kv.Key;
import oracle.kv.KeyValueVersion;
import oracle.kv.KVStore;
import oracle.kv.Value;
import oracle.kv.exttab.Formatter;

/**
 * A simple Formatter implementation used by the External Tables Cookbook
 * example. This class formats UserInfo records from the NoSQL Database to be
 * suitable for reading by the NOSQL_DATA Oracle Database table. The {@link
 * oracle.kv.exttab.Formatter#toOracleLoaderFormat} method accepts a {@link
 * oracle.kv.KeyValueVersion} and returns a String which can be interpreted by
 * the ACCESS PARAMETERS of the External Table definition.
 */
public class MyFormatter implements Formatter {
    private static final String USER_OBJECT_TYPE = "user";
    private static final String INFO_PROPERTY_NAME = "info";

    /**
     * @hidden
     */
    public MyFormatter() {}

    @Override
    public String toOracleLoaderFormat(final KeyValueVersion kvv,
                                       final KVStore kvStore) {
        final Key key = kvv.getKey();
        final Value value = kvv.getValue();

        final List<String> majorPath = key.getMajorPath();
        final List<String> minorPath = key.getMinorPath();
        final String objectType = majorPath.get(0);

        if (!USER_OBJECT_TYPE.equals(objectType)) {
            throw new IllegalArgumentException("Unknown object type: " + key);
        }

        final String email = majorPath.get(1);
        final String propertyName =
            (minorPath.size() > 0) ? minorPath.get(0) : null;

        if (INFO_PROPERTY_NAME.equals(propertyName)) {
            final ByteArrayInputStream bais =
                new ByteArrayInputStream(value.getValue());
            final DataInputStream dis = new DataInputStream(bais);

            try {

                /* Name is not used. */
                /* final String name = */ readString(dis);
                final char gender = dis.readChar();
                final String address = readString(dis);
                final String phone = readString(dis);
                final StringBuilder sb = new StringBuilder();
                sb.append(email).append("|");
                sb.append(gender).append("|");
                sb.append(address).append("|");
                sb.append(phone);
                return sb.toString();
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }

        return null;
    }

    private String readString(final DataInput in)
        throws IOException {

        if (!in.readBoolean()) {
            return null;
        }

        return in.readUTF();
    }
}
