(function() {
    const e = document.createElement("link").relList;
    if (e && e.supports && e.supports("modulepreload"))
        return;
    for (const n of document.querySelectorAll('link[rel="modulepreload"]'))
        c(n);
    new MutationObserver(n => {
        for (const r of n)
            if (r.type === "childList")
                for (const a of r.addedNodes)
                    a.tagName === "LINK" && a.rel === "modulepreload" && c(a)
    }).observe(document, {
        childList: !0,
        subtree: !0
    });
    function o(n) {
        const r = {};
        return n.integrity && (r.integrity = n.integrity), n.referrerPolicy && (r.referrerPolicy = n.referrerPolicy), n.crossOrigin === "use-credentials" ? r.credentials = "include" : n.crossOrigin === "anonymous" ? r.credentials = "omit" : r.credentials = "same-origin", r
    }
    function c(n) {
        if (n.ep)
            return;
        n.ep = !0;
        const r = o(n);
        fetch(n.href, r)
    }
})();
const ct = Math.PI * 2,
    Mt = (t, e=0, o=1) => Math.min(Math.max(t, e), o),
    Qt = (t, e, o) => o === e ? e : (t - e) / (o - e),
    I = (t, e, o) => t * (o - e) + e,
    B = (t, e, o, c, n) => I(Qt(t, e, o), c, n),
    x = (t=0, e=1) => I(Math.random(), t, e),
    Zt = (t=0, e=1) => Math.round(x(t, e)),
    te = (t, e=1) => (t % e + e) % e,
    p = t => 20 * t * 2e3 ** -t,
    P = (t, e) => t[te(e, t.length)],
    ee = window.innerWidth < 500 ? 256 : 32768;
let i,
    z,
    F,
    j;
function ne(t) {
    i = new window.AudioContext,
    z = i.sampleRate,
    F = new GainNode(i, {
        gain: 0
    }),
    F.gain.linearRampToValueAtTime(1, i.currentTime + 1),
    t && (j = i.createAnalyser(), j.fftSize = ee);
    const e = At(5),
        o = At(50),
        c = oe(1, 1),
        n = i.createDynamicsCompressor(),
        r = i.createDynamicsCompressor(),
        a = i.createGain();
    return e.wet.value = .5, e.dry.value = 1, o.wet.value = 0, o.dry.value = 1, c.wet.value = 1, c.dry.value = .2, n.attack.value = .05, n.knee.value = 10, n.ratio.value = 3, n.release.value = .1, n.threshold.value = -20, r.attack.value = .003, r.knee.value = 5, r.ratio.value = 15, r.release.value = .01, r.threshold.value = -8, a.gain.value = .5, F.connect(o.input), o.output.connect(c.input), c.output.connect(e.input), e.output.connect(n).connect(r).connect(a), a.connect(i.destination), t && a.connect(j), {
        heavyDistortion: o
    }
}
function oe(t, e, o) {
    const c = i.createGain(),
        n = i.createGain(),
        r = i.createGain(),
        a = i.createGain(),
        f = i.createConvolver(),
        s = z * t,
        y = i.createBuffer(2, s, z),
        w = y.getChannelData(0),
        h = y.getChannelData(1);
    for (let l = 0; l < s; l++) {
        const v = l;
        w[l] = x(-1, 1) * (1 - v / s) ** e,
        h[l] = x(-1, 1) * (1 - v / s) ** e
    }
    return f.buffer = y, r.connect(n).connect(a), r.connect(f).connect(c).connect(a), {
        input: r,
        output: a,
        wet: c.gain,
        dry: n.gain
    }
}
function At(t) {
    const e = i.createGain(),
        o = i.createGain(),
        c = i.createGain(),
        n = i.createGain(),
        r = i.createWaveShaper();
    return r.curve = new Float32Array(z).map((a, f) => {
        const s = f * 2 / z - 1;
        return (3 + t) * Math.atan(Math.sinh(s * .25) * 5) / (Math.PI + t * Math.abs(s))
    }), c.connect(o).connect(n), c.connect(r).connect(e).connect(n), {
        input: c,
        output: n,
        wet: e.gain,
        dry: o.gain
    }
}
const ce = Zt(1, 5),
    D = 12,
    se = 27,
    re = 4,
    et = 16,
    ie = .1,
    ae = 13,
    le = 11,
    de = 37,
    T = 3e3,
    _ = 10,
    ue = 33,
    V = 12,
    fe = 1,
    bt = 500,
    Pt = 34,
    Ct = 17,
    U = ["sawtooth", "square", "triangle"],
    he = 130.813,
    M = 1,
    me = 256 / 243,
    J = 9 / 8,
    st = 32 / 27,
    S = 81 / 64,
    K = 4 / 3,
    Dt = 1024 / 729,
    A = 3 / 2,
    pe = 128 / 81,
    Tt = 27 / 16,
    Lt = 16 / 9,
    X = 243 / 128,
    St = [M, me, J, st, S, K, Dt, A, pe, Tt, Lt, X],
    ye = [M, J, S, K, A, Tt, X],
    we = [M, S, A],
    ve = [M, S, A, X],
    ge = [M, S, A, X, 2 * Dt],
    Me = [M, st, A],
    Ae = [M, st, A, Lt],
    be = [M, S, A, 2 * J],
    Pe = [M, S, A, 2 * K],
    Ce = [M, S, A, 2 * J, 2 * K],
    nt = [Ce, Me, Ae, be, Pe, we, ge, ve];
function Se(t=!1) {
    const e = ne(t),
        o = Ne(D),
        c = Nt(),
        n = Nt(),
        s = {
            active: 0,
            amplitude: 0,
            chord: 0,
            chorus: 0,
            detune: 0,
            distortion: 0,
            flicker: 0,
            pulse: 0,
            transposition: 0,
            oscillators: Array.from({
                length: D
            }, () => ({
                amplitude: 0,
                flicker: 0
            })),
            melody: {
                amplitude: 0,
                note: 0
            },
            bass: {
                amplitude: 0,
                note: 0
            }
        };
    function y(w, h) {
        const l = w / 1e3,
            v = Date.now() / 1e3,
            g = v / de,
            q = P(St, Math.floor(g)),
            O = q == 11 ? 12 : P(St, Math.ceil(g)),
            rt = I(g % 1, -1, 1) ** 13,
            Ft = B(rt, -1, 1, q, O),
            Y = he * Ft;
        s.transposition = Math.abs(rt);
        const it = Math.floor(v / le) % nt.length,
            Q = nt[it];
        s.chord = it / nt.length;
        const It = (w - h.effects.blorpAtMs) / 1e3,
            R = p(It / fe) ** .2;
        s.chorus = R;
        const H = (w - h.effects.detuneAtMs) / 1e3,
            b = p(10 * H / _) - p(4 * H / _) + p(2 * H / _) - p(H / _);
        s.detune = Math.abs(b);
        const at = Math.sin(ct * v / se),
            Ot = B(at, -1, 1, re, D);
        s.active = B(at, -1, 1, 0, 1);
        const W = (w - h.effects.distortAtMs) / 1e3,
            Gt = 1.5 * p(W / (V * .15)) - p(W / (V * .4)) - p(W / (V * .7)) + 1.5 * p(W / V),
            G = Mt(Math.abs(Gt));
        d(e.heavyDistortion.wet, G),
        d(e.heavyDistortion.dry, 1 - G),
        s.distortion = G;
        const lt = h.effects.doPulse * p(v % ce);
        s.pulse = lt;
        const Bt = lt * .2,
            jt = .5 * R,
            zt = .4 * Math.abs(b),
            Et = .1 * G;
        s.amplitude = 0,
        s.flicker = 0,
        o.forEach((N, k) => {
            const gt = Y * ot(Q, k) + x(-R * bt, R * bt);
            d(N.nodeLow.frequency, gt),
            d(N.nodeHigh.frequency, gt),
            d(N.nodeLow.detune, b * T),
            d(N.nodeHigh.detune, b * -T);
            const $t = Mt(Ot - k),
                _t = Math.PI * N.rand + l,
                Vt = $t * Math.sin(_t) ** 20,
                $ = Math.min(1, Vt + Bt + jt + zt + Et),
                Z = $ / D;
            s.oscillators[k].amplitude = $,
            s.amplitude += Z;
            const Ut = x(.5, 2),
                Jt = Math.PI * l / ae + Ut * k / D,
                Kt = Math.cos(Jt) ** 20,
                Xt = .5 * G,
                tt = Math.min(1, Kt + Xt),
                Yt = tt * ie;
            s.oscillators[k].flicker = $ * tt,
            s.flicker += $ * tt / D,
            d(N.gainLow.gain, h.oscillators[k] * Z),
            d(N.gainHigh.gain, h.flickers[k] * Z * Yt)
        });
        const dt = 4,
            ut = Math.floor(l / 2 % dt),
            ft = Y * ot(Q, ut) / 3;
        d(c.node1.frequency, ft),
        d(c.node2.frequency, ft),
        d(c.pan.pan, Math.sin(l / 2) * .2);
        const ht = p(s.amplitude * 2),
            Rt = h.effects.doBass * ht * .03;
        d(c.gain.gain, Rt),
        s.bass.amplitude = ht,
        s.bass.note = ut / dt,
        c.node1.type = P(U, Math.floor(l / Pt)),
        c.node2.type = P(U, Math.floor(l / Pt)),
        d(c.node1.detune, b * T),
        d(c.node2.detune, b * T);
        const mt = 4,
            Ht = 3;
        l * P(ye, Math.round(l));
        const pt = Ht + Math.floor((l + x(-.2, .2)) / 2) % mt,
            yt = Y * ot(Q, pt);
        d(n.node1.frequency, yt),
        d(n.node2.frequency, yt),
        d(n.pan.pan, Math.sin(l / 2) * .2);
        const wt = p(s.amplitude * 2),
            Wt = h.effects.doMelody * wt * .03;
        d(n.gain.gain, Wt),
        s.melody.amplitude = wt,
        s.melody.note = pt / mt,
        n.node1.type = P(U, Math.floor(l / Ct)),
        n.node2.type = P(U, Math.floor(l / Ct));
        const vt = 20 * Math.sin(Math.PI * l / ue) ** 4;
        d(n.node1.detune, b * T + vt),
        d(n.node2.detune, b * T - vt)
    }
    return {
        tick: y,
        state: s
    }
}
const ot = (t, e) => {
    const o = Math.floor(e / t.length);
    return P(t, e) * 2 ** o
};
function d(t, e) {
    t.linearRampToValueAtTime(e, i.currentTime + 1 / 120)
}
function Ne(t) {
    return Array.from({
        length: t
    }, (e, o) => {
        const c = new OscillatorNode(i),
            n = new OscillatorNode(i),
            r = o % 2 == 0 ? 1 : -1,
            a = new StereoPannerNode(i, {
                pan: B(o, 0, t, 0, r)
            }),
            f = new StereoPannerNode(i, {
                pan: B(o, 0, t, 0, -r)
            });
        let s = new Float32Array(et),
            y = new Float32Array(et);
        s = s.map((v, g) => {
            if (g == 0)
                return 0;
            let q = (g - 1) / (et - 1);
            return q **= 1e-4, I(q, 1, 0)
        }),
        c.setPeriodicWave(i.createPeriodicWave(s, y, {
            disableNormalization: !0
        })),
        s = s.map((v, g) => g == 0 ? 0 : 1),
        n.setPeriodicWave(i.createPeriodicWave(s, y, {
            disableNormalization: !0
        }));
        const w = new GainNode(i),
            h = new GainNode(i);
        c.connect(w).connect(a).connect(F),
        n.connect(h).connect(f).connect(F),
        c.start(),
        n.start();
        const l = Math.random();
        return {
            nodeLow: c,
            nodeHigh: n,
            gainLow: w,
            gainHigh: h,
            rand: l
        }
    })
}
function Nt() {
    const t = new OscillatorNode(i),
        e = new OscillatorNode(i),
        o = new StereoPannerNode(i),
        c = new GainNode(i);
    return t.connect(c), e.connect(c), c.connect(o).connect(F), t.start(), e.start(), {
        node1: t,
        node2: e,
        pan: o,
        gain: c
    }
}
const ke = !0,
    E = document.querySelector("main canvas"),
    u = E.getContext("2d");
let kt = window.innerWidth,
    qt = window.innerHeight;
const C = {
        x: 0,
        y: 0,
        down: !1
    },
    L = {
        orientation: {
            x: 0,
            y: 0,
            z: 0
        },
        oscillators: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        flickers: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        effects: {
            blorpAtMs: -1e5,
            detuneAtMs: -1e5,
            distortAtMs: -1e5,
            doBass: 0,
            doMelody: 0,
            doPulse: 0
        }
    };
async function qe() {
    document.querySelector("h1").remove();
    try {
        navigator.wakeLock.request("screen")
    } catch {}
    const t = Se(ke);
    function e(o) {
        t.tick(o, L),
        u.clearRect(0, 0, E.width, E.height),
        De(t.state),
        Te(t.state, o),
        C.down = !1,
        requestAnimationFrame(e)
    }
    requestAnimationFrame(e)
}
function De(t) {
    const e = j.frequencyBinCount,
        o = new Uint8Array(e);
    j.getByteFrequencyData(o);
    const c = I(t.flicker, 40, 100),
        n = I(t.transposition, 20, 200),
        r = t.chord * 360;
    u.fillStyle = `lch(${c} ${n} ${r})`;
    for (let a = 0; a < e; a++) {
        let f = a / e;
        const s = a % 2 == 0 ? 1 : -1,
            y = window.innerWidth / 2,
            w = y + f * s * y,
            h = (1 - o[a] / 256) * window.innerHeight,
            l = 5 * t.distortion,
            v = (1 - f) ** 2,
            g = 1.5 * t.amplitude + .5;
        let O = (l + v) * g + .2;
        u.fillRect(w - 2 * O, h, 4 * O, 8 * O)
    }
}
function Te(t, e) {
    t.oscillators.forEach((c, n) => {
        const r = L.oscillators[n],
            a = L.flickers[n];
        m(`osc ${n} amp`, 1, n, c.amplitude, r, () => L.oscillators[n] = r == 1 ? 0 : 1),
        m(`osc ${n} flicker`, 2, n, c.flicker, a, () => L.flickers[n] = a == 1 ? 0 : 1)
    });
    const o = L.effects;
    m("active", 0, 0, t.active, -1),
    m("amplitude", 0, 1, t.amplitude, -1),
    m("chord", 0, 2, t.chord, -1),
    m("flicker", 0, 3, t.flicker, -1),
    m("transposition", 0, 4, t.transposition, -1),
    m("chorus", 0, 6, t.chorus, t.chorus, () => o.blorpAtMs = e),
    m("detune", 0, 7, t.detune, t.detune, () => o.detuneAtMs = e),
    m("distortion", 0, 8, t.distortion, t.distortion, () => o.distortAtMs = e),
    m("bass", 0, 9, t.bass.amplitude, o.doBass, () => o.doBass = o.doBass == 0 ? 1 : 0),
    m("melody", 0, 10, t.melody.amplitude, o.doMelody, () => o.doMelody = o.doMelody == 0 ? 1 : 0),
    m("pulse", 0, 11, t.pulse, o.doPulse, () => o.doPulse = o.doPulse == 0 ? 1 : 0)
}
function m(t, e, o, c, n, r) {
    u.beginPath(),
    u.fillStyle = "#0001";
    const a = 25 + e * 150,
        f = 25 + o * 45,
        s = 20;
    u.arc(a, f, s, 0, ct),
    u.fill(),
    u.beginPath(),
    u.fillStyle = n < 0 ? "#fff" : n > .01 ? "lch(65% 132 178)" : "#333",
    u.arc(a, f, Math.max(0, s * c), 0, ct),
    u.fill(),
    u.fillText(t, 50 + e * 150, f),
    C.down && Le(a, f) <= s && r && r()
}
function Le(t, e) {
    return Math.sqrt((t - C.x) ** 2 + (e - C.y) ** 2)
}
function xt() {
    const t = window.devicePixelRatio;
    kt = window.innerWidth,
    qt = window.innerHeight,
    E.width = t * kt,
    E.height = t * qt,
    u.resetTransform(),
    u.scale(t, t),
    u.font = "12px sans-serif",
    u.textAlign = "left",
    u.textBaseline = "middle",
    u.lineCap = "round",
    u.lineJoin = "round"
}
window.addEventListener("resize", xt);
xt();
window.addEventListener("pointermove", t => {
    C.x = t.clientX,
    C.y = t.clientY
});
window.addEventListener("pointerdown", t => C.down = !0);
window.addEventListener("pointerup", t => C.down = !1);
window.addEventListener("pointerup", qe, {
    once: !0
});
