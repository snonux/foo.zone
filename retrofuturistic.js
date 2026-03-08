(function () {
    'use strict';

    var doc = document;
    var root = doc.documentElement;
    var body = doc.body;
    var reduceMotion = false;
    var starsResizeTimer = 0;

    try {
        reduceMotion = !!(window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches);
    } catch (err) {
        reduceMotion = false;
    }

    if (reduceMotion) {
        root.classList.add('reduce-motion');
    }

    function eachNode(nodeList, fn) {
        var i;
        for (i = 0; i < nodeList.length; i += 1) {
            fn(nodeList[i], i);
        }
    }

    function markRevealAnimations() {
        var selector = 'p.header, h1, h2, h3, span, li, pre, img, p.footer';
        var nodes = doc.querySelectorAll(selector);
        var delayMs = 0;

        eachNode(nodes, function (node) {
            node.classList.add('rfx-reveal');
            node.style.setProperty('--rfx-delay', String(delayMs) + 'ms');
            delayMs += 18;
            if (delayMs > 900) {
                delayMs = 900;
            }
        });
    }

    function buildStars() {
        var container = doc.getElementById('rfx-stars');
        var palette = ['#ffffff', '#2ef7ff', '#ff2fa9', '#8eff58'];
        var starCount = reduceMotion ? 30 : 130;
        var i;

        if (!container) {
            return;
        }

        container.textContent = '';
        for (i = 0; i < starCount; i += 1) {
            var star = doc.createElement('span');
            var size = (Math.random() * 2.9) + 0.6;

            star.className = 'star';
            star.style.left = (Math.random() * 100).toFixed(2) + '%';
            star.style.top = (Math.random() * 100).toFixed(2) + '%';
            star.style.width = size.toFixed(2) + 'px';
            star.style.height = size.toFixed(2) + 'px';
            star.style.opacity = ((Math.random() * 0.65) + 0.2).toFixed(2);
            star.style.animationDelay = (Math.random() * 5).toFixed(2) + 's';
            star.style.setProperty('--twinkle-speed', ((Math.random() * 4.8) + 1.8).toFixed(2) + 's');
            star.style.backgroundColor = palette[Math.floor(Math.random() * palette.length)];

            container.appendChild(star);
        }
    }

    function installGlitchPulse() {
        var headings = doc.querySelectorAll('h1, h2, h3');
        var timerDelay = reduceMotion ? 3600 : 1300;

        eachNode(headings, function (heading) {
            heading.setAttribute('data-rfx-text', heading.textContent || '');
        });

        if (reduceMotion || headings.length === 0) {
            return;
        }

        window.setInterval(function () {
            var target = headings[Math.floor(Math.random() * headings.length)];
            var life = 170 + Math.floor(Math.random() * 180);

            target.classList.add('glitch');
            window.setTimeout(function () {
                target.classList.remove('glitch');
            }, life);
        }, timerDelay);
    }

    function installCursorBurst() {
        var lastBurstAt = 0;

        if (reduceMotion) {
            return;
        }

        doc.addEventListener('mousemove', function (event) {
            var now = Date.now();
            var spark;

            if (now - lastBurstAt < 68) {
                return;
            }
            lastBurstAt = now;

            spark = doc.createElement('span');
            spark.className = 'rfx-cursor-burst';
            spark.style.left = String(event.clientX) + 'px';
            spark.style.top = String(event.clientY) + 'px';

            body.appendChild(spark);
            window.setTimeout(function () {
                if (spark.parentNode) {
                    spark.parentNode.removeChild(spark);
                }
            }, 470);
        });
    }

    function installScrollTracking() {
        function writeScrollDepth() {
            var scrollY = window.scrollY || window.pageYOffset || 0;
            root.style.setProperty('--rfx-scroll', String(scrollY) + 'px');
        }

        writeScrollDepth();
        doc.addEventListener('scroll', function () {
            window.requestAnimationFrame(writeScrollDepth);
        });
    }

    function installLinkPulses() {
        var links = doc.querySelectorAll('a.textlink');

        eachNode(links, function (link) {
            link.addEventListener('mouseenter', function () {
                link.classList.add('link-pulse');
                window.setTimeout(function () {
                    link.classList.remove('link-pulse');
                }, 320);
            });
        });
    }

    function installResizeRefresh() {
        if (reduceMotion) {
            return;
        }

        window.addEventListener('resize', function () {
            window.clearTimeout(starsResizeTimer);
            starsResizeTimer = window.setTimeout(buildStars, 220);
        });
    }

    function init() {
        markRevealAnimations();
        buildStars();
        installGlitchPulse();
        installCursorBurst();
        installScrollTracking();
        installLinkPulses();
        installResizeRefresh();
        root.classList.add('rfx-ready');
        body.classList.remove('rfx-boot');
    }

    if (doc.readyState === 'loading') {
        doc.addEventListener('DOMContentLoaded', init);
        return;
    }

    init();
}());
