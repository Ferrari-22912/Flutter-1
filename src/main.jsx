import React, { useState } from 'react';
import { createRoot } from 'react-dom/client';
import { ArrowDown, ArrowLeft, ArrowRight, Check, Heart, IceCreamCone, KeyRound, Menu, Sparkles, X } from 'lucide-react';
import './styles.css';

const pages = [
  { id: 'letter', label: 'A little letter', number: '01' },
  { id: 'treat', label: 'A sweet promise', number: '02' },
  { id: 'breathe', label: 'A place to breathe', number: '03' },
];

function validDate(value) {
  const normalized = value.trim().toLowerCase().replace(/\s+/g, ' ');
  const digits = normalized.replace(/\D/g, '');
  if (digits === '24042002') return true;
  return /^24(?:st|nd|rd|th)?[\s,./-]+(?:april|apr)[\s,./-]+2002$/.test(normalized) || /^(?:april|apr)[\s,./-]+24(?:st|nd|rd|th)?[\s,./-]+2002$/.test(normalized);
}

function Brand({ onClick }) {
  return <button className="brand" onClick={onClick} aria-label="A little space for Ashiii, home"><span className="brand-mark">a<span>♡</span></span><span className="brand-copy">a little space <i>for</i><br/><strong>ASHIII</strong></span></button>;
}

function Header({ unlocked, page, navigate }) {
  const [open, setOpen] = useState(false);
  return <header className="header">
    <Brand onClick={() => unlocked && navigate('letter')} />
    {unlocked ? <>
      <nav className={open ? 'nav open' : 'nav'} aria-label="Main navigation">
        {pages.map(item => <button key={item.id} className={page === item.id ? 'nav-link active' : 'nav-link'} onClick={() => { navigate(item.id); setOpen(false); }}>{item.label}</button>)}
      </nav>
      <div className="header-right"><span className="header-heart">made with <Heart size={13} fill="currentColor" /> for you</span><button className="menu-toggle" aria-label={open ? 'Close menu' : 'Open menu'} onClick={() => setOpen(!open)}>{open ? <X size={21}/> : <Menu size={21}/>}</button></div>
    </> : <div className="header-right"><span className="header-heart">made with <Heart size={13} fill="currentColor" /> for you</span></div>}
  </header>;
}

function LockScreen({ onUnlock }) {
  const [value, setValue] = useState('');
  const [error, setError] = useState(false);
  const [unlocking, setUnlocking] = useState(false);
  function submit(e) {
    e.preventDefault();
    if (unlocking) return;
    if (validDate(value)) {
      setError(false); setUnlocking(true);
      window.setTimeout(onUnlock, 1500);
    } else {
      setError(false);
      requestAnimationFrame(() => setError(true));
    }
  }
  return <div className={'lock-page ' + (unlocking ? 'leaving' : '')}>
    <Header />
    <main className="lock-main">
      <div className="lock-copy">
        <div className="eyebrow"><span className="small-star">✦</span> A LITTLE SOMETHING, JUST FOR YOU</div>
        <h1>For the one<br/>who makes life<br/><em>softer.</em></h1>
        <p>A little corner of the world, made especially for you. Whenever you need a reminder of how loved you are, you'll find it here.</p>
        <div className="signature-line"><span>WITH ALL MY HEART,</span><span className="handwritten">Ibi <span>♡</span></span></div>
      </div>
      <section className={'unlock-card ' + (error ? 'shake' : '') + (unlocking ? ' unlocking' : '')} aria-labelledby="unlock-title">
        <div className="card-corner top-left">✧</div><div className="card-corner bottom-right">✧</div>
        <div className="lock-illustration" aria-hidden="true">
          <div className="orbit orbit-one"></div><div className="orbit orbit-two"></div>
          <span className="spark spark-a">✦</span><span className="spark spark-b">✧</span><span className="spark spark-c">✦</span>
          <div className="lock-halo"><svg className="lock-icon" viewBox="0 0 48 48" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"><path className="shackle" d="M14 20v-7a10 10 0 0 1 20 0v7"/><rect x="10" y="20" width="28" height="22" rx="4"/><circle cx="24" cy="29" r="2"/><path d="M24 31v4"/></svg><KeyRound className="key-icon" strokeWidth={1.4}/></div>
        </div>
        <div className="card-kicker">A LITTLE SECRET BETWEEN US</div>
        <h2 id="unlock-title">This space is <em>yours.</em></h2>
        <p className="card-intro">A little love note is waiting on the other side.</p>
        <form onSubmit={submit}>
          <label htmlFor="secret">THE SECRET KEY</label>
          <div className="input-wrap"><KeyRound size={17}/><input id="secret" type="text" value={value} onChange={e => {setValue(e.target.value); setError(false);}} placeholder="Enter your secret here" autoComplete="off" aria-describedby="hint error" /></div>
          <div className="hint" id="hint">Hint: A date very close to your heart <span>♡</span></div>
          <div className="error" id="error" aria-live="polite">{error ? 'Nice try, Motiiiiii! Think a little harder ♡' : '\u00a0'}</div>
          <button className="primary-button" type="submit" disabled={unlocking}>{unlocking ? 'Opening with love...' : 'Unlock your little space'} <ArrowRight size={16}/></button>
        </form>
        <div className="card-bottom">JUST FOR ASHIII <span>✦</span> ALWAYS</div>
      </section>
    </main>
    <div className="lock-footer"><span>MADE FOR YOU, MOTIIIIII ♡</span><span>A LITTLE LOVE GOES A LONG WAY <span className="footer-star">✦</span></span></div>
  </div>;
}

function PageIntro({ kicker, title, italic, description, number }) {
  return <div className="page-intro"><div><div className="eyebrow"><span className="small-star">✦</span> {kicker}</div><h1>{title} <em>{italic}</em></h1><p>{description}</p></div><div className="page-number"><span>0{number}</span> / 03</div></div>;
}

function Letter({ navigate }) {
  return <div className="page-content letter-page">
    <div className="hero-panel">
      <div className="hero-image"></div><div className="hero-overlay"></div>
      <div className="hero-content"><div className="eyebrow"><span className="small-star">✦</span> A LITTLE CORNER OF THE WORLD, JUST FOR YOU</div><h1>For you,<br/><em>Ashiii.</em> <span className="hero-heart">♡</span></h1><p>A soft place to land, a reminder to breathe, and a little bit of love for whenever you need it.</p><button className="text-link" onClick={() => document.getElementById('letter').scrollIntoView({ behavior: 'smooth' })}>A LETTER FOR YOU <ArrowDown size={15}/></button></div>
      <div className="hero-side">A LITTLE SPACE TO JUST BE <span>✦</span> MADE WITH LOVE</div>
      <div className="hero-bottom"><span>YOUR SAFE LITTLE SPACE</span><span>EST. WITH LOVE ♡</span></div>
    </div>
    <div className="section-heading" id="letter"><div><div className="eyebrow"><span className="small-star">✦</span> WORDS FROM THE HEART</div><h2>A little letter, <em>just for you.</em></h2></div><span className="section-index">01 / 03</span></div>
    <div className="letter-layout"><aside className="letter-aside"><span className="aside-icon">♡</span><p>For the days you<br/><em>need a little extra love.</em></p><span className="aside-line"></span><small>KEEP THIS CLOSE</small></aside>
      <article className="letter-paper"><div className="paper-top"><span>TO MY DEAREST ASHIII</span><span>♡</span></div><h3>Hey, Motiiiiii <span>♡</span></h3><p>I hope you know how incredibly amazing you are. Even on the days when you don't feel like yourself, there is so much strength and beauty in you.</p><p>I know things have been a little tough lately. The mood swings, the pain, the vomiting — pregnancy can ask so much of you. Please be gentle with yourself, Motiiiiii. You don't have to be strong every single second.</p><p>Take it one breath, one moment, one day at a time. Everything is going to be okay, and I hope you always believe in yourself the way I believe in you.</p><p>And remember, I'm right here. For anything you need, at any time. You can share <em>literally anything</em> with me — the big things, the little things, or nothing at all. You never have to go through it alone.</p><p>You've got this, Motiiiiii. And you've always got me.</p><div className="letter-signoff">Always here for you,<br/><span>Ibi ♡</span></div><div className="paper-bottom">A LITTLE REMINDER: YOU ARE SO, SO LOVED <span>✦</span></div></article>
    </div>
    <div className="next-section"><div><span>THERE'S MORE LOVE AHEAD</span><h3>A little something <em>sweet.</em></h3></div><button className="round-link" onClick={() => navigate('treat')} aria-label="Go to A sweet promise"><ArrowRight size={20}/></button></div>
  </div>;
}

function Treat({ navigate }) {
  const [saved, setSaved] = useState(false);
  return <div className="page-content inner-page"><PageIntro kicker="SOMETHING SWEET FOR SOMEONE SWEET" title="A promise that's" italic="extra sweet." description="Because cravings deserve to be taken very, very seriously." number={2}/>
    <div className="treat-layout"><div className="treat-copy"><div className="icon-medallion"><IceCreamCone size={34} strokeWidth={1.2}/></div><span className="mini-label">FOR MY FAVORITE MOTIIIIII</span><h2>Let's make life a little <em>sweeter.</em></h2><p>For every craving, every tough day, and every moment that could use a little scoop of happiness — here's a promise from me to you.</p><p>Pick your favorite flavor (or all of them). The only rule is that you enjoy every bite.</p><div className="flavors"><span>♡ EXTRA SCOOPS</span><span>♡ NO SHARING REQUIRED</span></div></div>
    <div className="coupon"><div className="coupon-top"><span>THE OFFICIAL SWEET TREAT TICKET</span><Sparkles size={17}/></div><div className="coupon-art"><span className="floating-star">✦</span><IceCreamCone size={83} strokeWidth={0.8}/><span className="floating-star">✧</span></div><div className="coupon-label">REDEEMABLE FOR</div><h3>All the ice cream<br/><em>your heart desires.</em></h3><p>Whenever you come to Islamabad, I am officially treating you to all the ice cream you want!</p><div className="coupon-divider"><span>✦</span></div><div className="coupon-meta"><span>VALID: ALWAYS</span><span>FROM: IBI ♡</span></div><button className="coupon-button" onClick={() => setSaved(!saved)}>{saved ? <><Check size={16}/> PROMISE KEPT CLOSE</> : <>KEEP THIS PROMISE <Heart size={16}/></>}</button><small>{saved ? 'This promise is yours, always ♡' : 'A little promise, just for you'}</small></div></div>
    <div className="next-section"><div><span>WHENEVER YOU NEED A MOMENT</span><h3>Find a little <em>quiet.</em></h3></div><button className="round-link" onClick={() => navigate('breathe')} aria-label="Go to A place to breathe"><ArrowRight size={20}/></button></div>
  </div>;
}

function Breathe({ navigate }) {
  return <div className="page-content inner-page"><PageIntro kicker="A QUIET MOMENT FOR YOU" title="Take a breath," italic="Motiiiiii." description="A little escape for the days that feel like too much. There's no rush here." number={3}/>
    <div className="breathe-quote"><span>✦</span><p>“You don't have to do it all today.<br/><em>Just take it one breath at a time.</em>”</p><span>✦</span></div>
    <div className="gallery-heading"><div><div className="eyebrow"><span className="small-star">✦</span> A LITTLE PEACE, JUST FOR YOU</div><h2>Stay here <em>awhile.</em></h2></div><p>Little moments of calm, collected for you.</p></div>
    <div className="gallery"><figure className="gallery-card"><img src="/margalla.png" alt="The Margalla Hills at a peaceful dusk"/><figcaption><span>01 / A LITTLE ESCAPE</span><h3>Somewhere in Islamabad</h3><p>Where the hills meet the quiet.</p></figcaption></figure><figure className="gallery-card"><img src="/cozy.png" alt="A warm, cozy window glowing on a rainy night"/><figcaption><span>02 / A SOFT PLACE</span><h3>Slow, cozy evenings</h3><p>Let the world wait a little.</p></figcaption></figure><figure className="gallery-card"><img src="/ashiii-night.png" alt="A dreamy moon above quiet mountains"/><figcaption><span>03 / A GENTLE REMINDER</span><h3>Under the same sky</h3><p>You're never as alone as you feel.</p></figcaption></figure></div>
    <div className="next-section"><div><span>COME BACK WHENEVER YOU NEED</span><h3>There's always <em>love here.</em></h3></div><button className="round-link" onClick={() => navigate('letter')} aria-label="Return to the letter"><ArrowLeft size={20}/></button></div>
  </div>;
}

function App() {
  const [unlocked, setUnlocked] = useState(false);
  const [page, setPage] = useState('letter');
  function navigate(id) { setPage(id); window.scrollTo({ top: 0, behavior: 'smooth' }); }
  if (!unlocked) return <LockScreen onUnlock={() => setUnlocked(true)}/>;
  return <div className="site"><Header unlocked page={page} navigate={navigate}/><main key={page} className="page-transition">{page === 'letter' ? <Letter navigate={navigate}/> : page === 'treat' ? <Treat navigate={navigate}/> : <Breathe navigate={navigate}/>}</main><footer className="site-footer"><Brand onClick={() => navigate('letter')}/><p>Made with a whole lot of love, just for you.</p><span>ALWAYS HERE FOR YOU ♡</span></footer></div>;
}

createRoot(document.getElementById('root')).render(<App />);
