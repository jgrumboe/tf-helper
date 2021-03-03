#!/bin/sh

## -------------------------------------------------------------------
##
## Copyright (c) 2018 HashiCorp. All Rights Reserved.
##
## This file is provided to you under the Mozilla Public License
## Version 2.0 (the "License"); you may not use this file
## except in compliance with the License.  You may obtain
## a copy of the License at
##
##   https://www.mozilla.org/en-US/MPL/2.0/
##
## Unless required by applicable law or agreed to in writing,
## software distributed under the License is distributed on an
## "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
## KIND, either express or implied.  See the License for the
## specific language governing permissions and limitations
## under the License.
##
## -------------------------------------------------------------------

tfh_state_current() {
  state_ws="$1"

  if [ -z "$state_ws" ]; then
    if ! check_required ws; then
      echoerr 'For state commands, a positional parameter is also accepted:'
      echoerr 'tfh state show WORKSPACE_NAME'
      return 1
    else
      state_ws="$ws"
    fi
  fi

  . "$JUNONIA_PATH/lib/tfh/cmd/tfh_workspace.sh"
  if ! ws_id="$(_fetch_ws_id "$org" "$state_ws")"; then
    return 1
  fi

  echodebug "API request to show current state:"
  url="$address/api/v2/workspaces/$ws_id/current-state-version"
  if ! state_resp="$(tfh_api_call "$url")"; then
    echoerr "Error showing current state for $state_ws"
    return 1
  fi

printf "%s" "$state_resp"
}
