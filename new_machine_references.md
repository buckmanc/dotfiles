New Machine References
======================

## Bookmarks

- [ASCII Converter](https://www.branah.com/ascii-converter)
- [Old Regex Basics](https://web.archive.org/web/20130814132447/http://www.regular-expressions.info/reference.html)
- [Regex Lookarounds](https://miro.medium.com/v2/1*PRRHGdN32Mep-3KhLwvKzw.png)
- [Vim Cheat Sheet](https://vim.rtorr.com/)
- [SQL Server Data Types](https://web.archive.org/web/20161128134813/http://www.dummies.com/programming/sql/data-types-found-in-sql-server-2008)
- [SQL Data Types](https://www.w3schools.com/sql/sql_datatypes.asp)
- [Markdown Cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#headers)
- [Nerd Font Cheatsheet](https://www.nerdfonts.com/cheat-sheet)
- [ANSI Escape Sequences](https://stackoverflow.com/a/33206814)
- [Windows Environment Variables](https://ss64.com/nt/syntax-variables.html)
- [Regex Tester](https://regex101.com/)
- [ShellCheck](https://shellcheck.net)
- [Crontab.Guru](https://crontab.guru)
- [Gist Viewer](https://yi-jiayu.github.io/essence/)
- [No Hello](https://nohello.net)
- [Passwordless SSH](https://linuxize.com/post/how-to-setup-passwordless-ssh-login/)
- [Pokemon Go Raid Finder](https://9db.jp/pokego/data/62)
- [Pokemon Go Countdowns](https://p337.info/pokemongo/)
- [Market Holidays](https://www.nyse.com/markets/hours-calendars)
- [jq Cheat Sheet](https://gist.github.com/olih/f7437fb6962fb3ee9fe95bda8d2c8fa4)
- [bash filename parsing / extraction](https://stackoverflow.com/a/965069/1995812)
- [sqlite3 cheat sheet](https://sqlitetutorial.net/sqlite-commands)
- [dotnet ef commands](https://learn.microsoft.com/en-us/ef/core/cli/dotnet#using-the-tools)
- [JSON2CSharp (and XML, etc)](https://json2cscharp.com)
- [HTTP Status Codes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status)
- [URL Decode / Encode](https://urlencoder.org)

## Bookmarklets

- copy sanitized url - `javascript:void(navigator.clipboard.writeText(location.href.substring(0,location.href.search("(ref=|\\?)"))));`
- email - `javascript:void(window.open("mailto:example@example.com?subject=%22+encodeURIComponent(document.title)+%22&body=%22+document.location.href));`
- wayback - `javascript:location.href='http://web.archive.org/web/*/'+document.location.href; `
- gistfix - `javascript:(function(){var a=/^(?:.*\/)?([a-f0-9]+)$/.exec(window.location.href),b=a?a[1]:null;b&&(window.location.href=%27https://yi-jiayu.github.io/essence/#'+b);})()`
- puzzle from img - `javascript:post('https://www.jigsawexplorer.com/jigsaw-puzzle-result/',{'image-url':document.location.href,color:'charcoal','puzzle-nop':136});function post(a,b){const c=(e,f)=>Object.assign(document.createElement(e),f),d=c('form',{action:a,method:'post',hidden:true});for(const[e,f]of Object.entries(b))d.appendChild(c('input',{name:e,value:f}));document.body.appendChild(d),d.submit()}`


## Browser Extensions

#### Essentials

- [Dark Reader](https://darkreader.org/) - [Firefox](https://addons.mozilla.org/en-US/firefox/addon/darkreader/) [Chrome](https://chrome.google.com/webstore/detail/dark-reader/eimadpbcbfnmbkopoojfekhnkhdbieeh)
- [uBlock Origin](https://ublockorigin.com/) - [Firefox](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/) [Chrome](https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm)
- AutoplayStopper - [Chrome](https://chrome.google.com/webstore/detail/autoplaystopper/ejddcgojdblidajhngkogefpkknnebdh)
- Bypass Paywalls Clean - [Firefox](https://gitlab.com/magnolia1234/bypass-paywalls-firefox-clean/-/releases) [Chrome](https://gitlab.com/magnolia1234/bypass-paywalls-chrome-clean)
- Tracking Token Stripper - [Firefox](https://addons.mozilla.org/en-US/firefox/addon/utm-tracking-token-stripper/) [Chrome](https://chrome.google.com/webstore/detail/kcpnkledgcbobhkgimpbmejgockkplob)
- Transparent standalone images - [Firefox](https://addons.mozilla.org/en-US/firefox/addon/transparent-standalone-image/) [only needed for Firefox]

#### Dev & Downloads

- Link Gopher - [Firefox](https://addons.mozilla.org/en-US/firefox/addon/link-gopher/) [Chrome](https://chrome.google.com/webstore/detail/link-gopher/bpjdkodgnbfalgghnbeggfbfjpcfamkf)
- [DownThemAll!](https://www.downthemall.org/) - [Firefox](https://addons.mozilla.org/en-US/firefox/addon/downthemall/) [Chrome](https://chrome.google.com/webstore/detail/downthemall/nljkibfhlpcnanjgbnlnbjecgicbjkge)
- The Stream Detector - [Firefox](https://addons.mozilla.org/en-US/firefox/addon/hls-stream-detector/) [Chrome](https://chrome.google.com/webstore/detail/the-stream-detector/iakkmkmhhckcmoiibcfjnooibphlobak)
- ~~JsonVue - [Chrome](https://chrome.google.com/webstore/detail/jsonvue/chklaanhfefbnpoihckbnefhakgolnmc)~~
- JSON Formatter - [Chrome](https://chrome.google.com/webstore/detail/json-formatter/bcjindcccaagfpapjjmafapmmgkkhgoa)
- Open Frame - [Chrome](https://chrome.google.com/webstore/detail/open-frame/afoejdbdbdfpdhhemjoojjagmcpjjpla)
- Copy page title and url - [Firefox](https://addons.mozilla.org/en-US/firefox/addon/copy-page-title-and-url/) [Chrome](https://chrome.google.com/webstore/detail/copy-page-title-and-url/mcnddmglmjbomnfgkehnnblncllkaedm)
- Search by Image - [Firefox](https://addons.mozilla.org/firefox/addon/search_by_image/] [Chrome](https://chrome.google.com/webstore/detail/search-by-image/cnojnbdhbhnkbcieeekonklommdnndci)

#### Cosmetic

- Eight Dollars - [Firefox](https://addons.mozilla.org/en-US/firefox/addon/eightdollars/) [Chrome](https://chrome.google.com/webstore/detail/eight-dollars/fjbponfbognnefnmbffcfllkibbbobki)
- [Millenials to Snake People](https://github.com/ericwbailey/millennials-to-snake-people) - [Firefox](https://addons.mozilla.org/en-US/firefox/addon/millennials-to-snake-people/) [Chrome](https://chrome.google.com/webstore/detail/millennials-to-snake-peop/jhkibealmjkbkafogihpeidfcgnigmlf)

#### Misc

- Push to Kindle - [Firefox](https://addons.mozilla.org/en-US/firefox/addon/kindle-it/) [Chrome](https://chrome.google.com/webstore/detail/push-to-kindle/pnaiinchjaonopoejhknmgjingcnaloc)
- [Privacy Badger](https://privacybadger.org/) - [Firefox](https://addons.mozilla.org/en-US/firefox/addon/privacy-badger17/) [Chrome](https://chrome.google.com/webstore/detail/privacy-badger/pkehgijcmpdhfbdbbnkijodmdjhbjlgp)

## Emergency Music
- [Dungeon Synth Archives](https://youtube.com/@TheDungeonSynthArchives/videos)
- [LoFi Study Girl](https://youtube.com/watch?v=jfKfPfyJRdk)
- [LoFi Air Traffic Control](https://www.lofiatc.com/)
- [OC Remix Radio](https://rainwave.cc/ocremix/)
- ~~[Voices of the Ainur](https://www.podchaser.com/podcasts/voices-of-the-ainur-1487083/episodes/recent)~~
