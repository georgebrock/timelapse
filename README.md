# Timelapse #

A hacky little Sinatra app to take and display screenshots of web pages using
[webkit2png][1], because it's nice to look back and see how your site has
evolved over time.

Because it uses webkit2png, it has the same requirements: Mac OS X 10.2 or
later, Safari 1.0 or later, and PyObjC 1.1 or later

To take screenshots just send POST requests to `/take`. For example we run the
app at `http://screenshots` so we use this cron job to take screenshots at
midnight every night:

    0 0 * * * /opt/local/bin/curl -X POST http://screenshots/take

The app was inspired by a little script [Norm][2] wrote at [a fort][3].

[1]: http://www.paulhammond.org/webkit2png/
[2]: http://github.com/norm
[3]: http://devfort.com/comitatus/b/
