Gophish fork
=======

This is a fork of Gophish: Open-Source Phishing Toolkit [Gophish](https://getgophish.com)

### New features

This fork has a focus on running real-life phishing campaigns for a single customer. The following features are added:

- Script to automatically setup a fully configured Gophish instance on a fresh VPS. This allows you to have a single VPS for each of your customers. This helps preventing data leaks and you can completely destroy the VPS after you completed your campaigns.
- Support for running your landingpage on both HTTP & HTTPS (HTTP will 301 to HTTPS).
- Support for displaying a default landingpage if no RID is provided (instead of showing a 404).
- Automatically install Let's encrypt Certificates for your domains.
- Support for tracking the opening of malicious Word attachments and enabling Macro's inside these documents. 
- More to be developed...

More info: https://www.onvio.nl/nieuws/gophish-phishing

### Setup

Spin-up a fresh VPS and login as root and run:

```wget -N https://raw.githubusercontent.com/onvio/gophish/master/run.sh && chmod +x run.sh && source ./run.sh subdomain.phishingdomain.com,www.phishingdomain.com```

Your are now ready to go at https://www.phishingdomain.com:3333!

### Documentation

Documentation can be found on our [site](http://getgophish.com/documentation). Find something missing? Let us know by filing an issue!

### Issues

Find a bug? Want more features? Find something missing in the documentation? Let us know! Please don't hesitate to [file an issue](https://github.com/onvio/gophish/issues/new) and we'll get right on it.

### License
```
Gophish - Open-Source Phishing Framework

The MIT License (MIT)

Copyright (c) 2013 - 2018 Jordan Wright

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software ("Gophish Community Edition") and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
