#!/bin/bash

set -e

cmake --build build --config Release --target install --parallel $(nproc)