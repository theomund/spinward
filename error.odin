/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "base:runtime"
import "core:encoding/csv"
import "core:encoding/xml"
import "core:os"

Error :: union {
	csv.Error,
	os.Error,
	runtime.Allocator_Error,
	Spinward_Error,
	xml.Error,
}

Spinward_Error :: enum {
	Initialization_Failed,
	Invalid_Float,
	Invalid_Index,
	Invalid_Int,
	Invalid_Name,
}
