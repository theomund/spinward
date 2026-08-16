/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package main

import "base:runtime"
import "core:c/libc"
import "core:log"
import "core:mem"
import rl "vendor:raylib"

logger: log.Logger

log_buffer: []byte

log_callback :: proc "c" (logLevel: rl.TraceLogLevel, text: cstring, args: ^libc.va_list) {
	context = runtime.default_context()
	context.logger = logger

	level: log.Level

	switch logLevel {
	case .TRACE, .DEBUG:
		level = .Debug
	case .ALL, .NONE, .INFO:
		level = .Info
	case .WARNING:
		level = .Warning
	case .ERROR:
		level = .Error
	case .FATAL:
		level = .Fatal
	}

	if level < logger.lowest_level {
		return
	}

	if log_buffer == nil {
		log_buffer = make([]byte, 1024)
	}
	defer mem.zero_slice(log_buffer)

	n: int

	for n = int(libc.vsnprintf(raw_data(log_buffer), len(log_buffer), text, args));
	    n > len(log_buffer); {
		log.info("Resizing log buffer from %m to %m", len(log_buffer), len(log_buffer) * 2)
		log_buffer, _ = mem.resize_bytes(log_buffer, len(log_buffer) * 2)
	}

	formatted := string(log_buffer[:n])
	log.log(level, formatted)
}
