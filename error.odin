package main

import "core:encoding/csv"
import "core:os"

Error :: union {
	csv.Error,
	os.Error,
	Spinward_Error,
}

Spinward_Error :: enum {
	Initialization_Failed,
}
