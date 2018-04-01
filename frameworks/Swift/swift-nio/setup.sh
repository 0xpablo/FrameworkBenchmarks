#!/bin/bash

fw_depends swift

swift build -c release

.build/release/swift-nio-tfb-default &
