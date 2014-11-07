#!/bin/bash

# https://api.instagram.com/oauth/authorize/?client_id=104157b750514e4a8536356c00c33be2&redirect_uri=http://www.codebelay.com/callback&response_type=code
# http://localhost.com:3000/oauth/authorize/?client_id=51d203c441eed351041627f188a12dcbd095207a13dde49df625c6a0b9842b26&redirect_uri=http://www.codebelay.com/callback&response_type=code
# http://www.codebelay.com/callback?code=9cb1ccef981744cd90e4c4e3f8010888
# http://www.codebelay.com/callback?code=62744df7000942ba96ba79f0ffbca604

# http://localhost.com:3000/?code=7637a7f8df286f786beef7209415c8af10f54a3bfea9b5f823aecd29d9cee1d3
curl -F 'client_id=51d203c441eed351041627f188a12dcbd095207a13dde49df625c6a0b9842b26' \
    -F 'client_secret=2b032dce961d1a7c049f9d952046d5a190a05540c2277c443c072150577de158' \
    -F 'grant_type=authorization_code' \
    -F 'redirect_uri=http://localhost.com:3000' \
    -F 'code=7637a7f8df286f786beef7209415c8af10f54a3bfea9b5f823aecd29d9cee1d3' http://localhost.com:3000/oauth/token

# curl -F 'client_id=104157b750514e4a8536356c00c33be2' \
#     -F 'client_secret=775b6fb6efc1479ba72f961a37d5606e' \
#     -F 'grant_type=authorization_code' \
#     -F 'redirect_uri=http://www.codebelay.com/callback' \
#     -F 'code=62744df7000942ba96ba79f0ffbca604' https://api.instagram.com/oauth/access_token
