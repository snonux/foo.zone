(function () {
    'use strict';

    var doc = document;
    var root = doc.documentElement;
    var body = doc.body;
    var reduceMotion = false;
    var isCoarsePointer = false;
    var lowPowerMode = false;
    var starsResizeTimer = 0;

    try {
        reduceMotion = !!(window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches);
    } catch (err) {
        reduceMotion = false;
    }

    try {
        isCoarsePointer = !!(window.matchMedia && window.matchMedia('(pointer: coarse)').matches);
    } catch (err2) {
        isCoarsePointer = false;
    }

    lowPowerMode = reduceMotion || isCoarsePointer || ((navigator.hardwareConcurrency || 0) > 0 && navigator.hardwareConcurrency <= 4);

    if (reduceMotion) {
        root.classList.add('reduce-motion');
    }
    if (lowPowerMode) {
        root.classList.add('rfx-low-power');
    }

    function eachNode(nodeList, fn) {
        var i;
        for (i = 0; i < nodeList.length; i += 1) {
            fn(nodeList[i], i);
        }
    }

    function markRevealAnimations() {
        var selector = 'p.header, h1, h2, h3, pre, ul, li, img, a.textlink, p.footer';
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
        var starCount = reduceMotion ? 18 : (lowPowerMode ? 56 : 92);
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
        var timerDelay = reduceMotion ? 4200 : (lowPowerMode ? 2500 : 1400);

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
        var activeSparks = 0;

        if (reduceMotion || lowPowerMode || isCoarsePointer) {
            return;
        }

        doc.addEventListener('mousemove', function (event) {
            var now = Date.now();
            var spark;

            if (now - lastBurstAt < 120 || activeSparks > 14) {
                return;
            }
            lastBurstAt = now;

            spark = doc.createElement('span');
            spark.className = 'rfx-cursor-burst';
            spark.style.left = String(event.clientX) + 'px';
            spark.style.top = String(event.clientY) + 'px';

            body.appendChild(spark);
            activeSparks += 1;
            window.setTimeout(function () {
                if (spark.parentNode) {
                    spark.parentNode.removeChild(spark);
                }
                activeSparks -= 1;
            }, 470);
        });
    }

    function installScrollTracking() {
        var tick = false;

        function writeScrollDepth() {
            var scrollY = window.scrollY || window.pageYOffset || 0;
            root.style.setProperty('--rfx-scroll', String(scrollY) + 'px');
            tick = false;
        }

        writeScrollDepth();
        doc.addEventListener('scroll', function () {
            if (tick) {
                return;
            }
            tick = true;
            window.requestAnimationFrame(writeScrollDepth);
        });
    }

    function installLinkPulses() {
        doc.addEventListener('mouseover', function (event) {
            var link = event.target;
            if (!link || !link.classList || !link.classList.contains('textlink')) {
                return;
            }

            link.classList.add('link-pulse');
            window.clearTimeout(link._rfxPulseTimer);
            link._rfxPulseTimer = window.setTimeout(function () {
                link.classList.remove('link-pulse');
            }, 260);
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
    }

    if (doc.readyState === 'loading') {
        doc.addEventListener('DOMContentLoaded', init);
        return;
    }

    init();
}());
