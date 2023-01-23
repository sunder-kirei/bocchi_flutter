# Bocchi Flutter

So, basically this is an Anime streaming application. It uses `consumet` API under-the-hood for everything from searching to streaming. It uses `animepahe` as the stream provider and `gogoanime` for the info you see on the episode list, like episode title and episode description.

---

## Possible improvement

I chose gogoanime to display episode info because animepahe, simply, has no data about episodes, whatsoever. I would have gone with gogoanime's stream service as well, only if it was not broken to begin with. Well, animepahe was also broken but with a little string manipulation, I got it to work😉.

If you were to sacrifice info about episodes like their title and description, this app can be made a LOT faster. Since, I have to fetch both animepahe and gogoanime endpoints, the app is a little slow, but nothing deal-breaking. But if you would like to have a little extra speed, just rename the `video_player_screen_animepahe.dart` to `video_player_screen.dart`, and delete the old one, build the app, and it should work just fine, OR, I can just add an in-app switch!

---

## Fixing the consumet 403 error

The stream sources from consumet are plain broken. Well, zoro is working but you'll have to manually manage all the soft-subtitles. Well, I got animepahe to work!

TLDR; if you get a url that looks something like this from animepahe-

```
https://eu-{some-three-digit-code}.cache.nextcdn.org/hls/10/08/.../owo.m3u8

https://na-{some-three-digit-code}.cache.nextcdn.org/hls/10/08/.../owo.m3u8
```

just replace the `.cache.` segment with `.files.` It will work like a charm! Finally, it should look something like this-

```
https://eu-{some-three-digit-code}.files.nextcdn.org/hls/10/08/.../owo.m3u8

https://na-{some-three-digit-code}.files.nextcdn.org/hls/10/08/.../owo.m3u8
```
---
That's all, Bye 👋👋👋