function toast(msg){
  const el=document.getElementById('toast');
  if(!el) return;
  el.textContent=msg; el.classList.add('show');
  setTimeout(()=>el.classList.remove('show'),1800);
}
document.addEventListener('click', e=>{
  const b=e.target.closest('[data-toast]');
  if(b){e.preventDefault();toast(b.dataset.toast)}
});
document.querySelectorAll('form.demo-form').forEach(f=>{
  f.addEventListener('submit',e=>{
    e.preventDefault();
    toast('Demo submitted successfully — backend not connected yet.');
  })
});
const search=document.getElementById('searchInput');
if(search){
  search.addEventListener('input',()=>{
    const q=search.value.toLowerCase().trim();
    document.querySelectorAll('.cat').forEach(c=>{
      c.style.display=(!q||c.innerText.toLowerCase().includes(q))?'block':'none';
    });
  });
}

document.querySelectorAll('.cat[data-cat]').forEach(card=>{
  card.addEventListener('click',()=>{
    const category=(card.dataset.cat||'').trim();
    if(category==='Fashion'){
      window.location.href='fashion.html';
      return;
    }
    window.location.href='category.html?cat='+encodeURIComponent(category);
  });
});

// PIN selector. Launch area is currently Dubrajpur 731123.
(function(){
  const panel=document.getElementById('pinPanel');
  const open=document.getElementById('openPin');
  const close=document.getElementById('closePin');
  const check=document.getElementById('checkPin');
  const input=document.getElementById('pinInput');
  const result=document.getElementById('pinResult');
  const label=document.getElementById('activePinLabel');
  if(!panel||!open||!close||!check||!input||!result) return;

  function show(){panel.classList.add('show');panel.setAttribute('aria-hidden','false');setTimeout(()=>input.focus(),50)}
  function hide(){panel.classList.remove('show');panel.setAttribute('aria-hidden','true')}
  function validate(){
    const pin=input.value.replace(/\D/g,'').slice(0,6);
    input.value=pin;
    result.className='pin-result';
    if(pin.length!==6){result.textContent='Please enter a valid 6-digit PIN.';result.classList.add('no');return}
    if(pin==='731123'){
      result.textContent='✓ Service area active: Dubrajpur, Birbhum, West Bengal.';
      result.classList.add('ok');
      if(label) label.textContent='731123 — Dubrajpur, Birbhum';
      try{localStorage.setItem('meelocPin','731123')}catch(e){}
      setTimeout(hide,850);
    }else{
      result.textContent='Not service available yet for this PIN. MeeLoc is launching first in 731123.';
      result.classList.add('no');
    }
  }
  open.addEventListener('click',show);close.addEventListener('click',hide);check.addEventListener('click',validate);
  input.addEventListener('keydown',e=>{if(e.key==='Enter')validate()});
  panel.addEventListener('click',e=>{if(e.target===panel)hide()});
  document.addEventListener('keydown',e=>{if(e.key==='Escape')hide()});
})();

// MeeLoc homepage slider: continuous autoplay + arrows + dots + keyboard + swipe.
(function(){
  const slider=document.querySelector('.hero-slider');
  if(!slider) return;
  const slides=[...slider.querySelectorAll('.slide')];
  const dots=[...slider.querySelectorAll('.dot')];
  const prev=slider.querySelector('.slider-arrow.prev');
  const next=slider.querySelector('.slider-arrow.next');
  if(slides.length<2) return;
  let index=0;let timer=null;let startX=0;const AUTOPLAY=4000;
  function show(i){
    index=(i+slides.length)%slides.length;
    slides.forEach((slide,n)=>slide.classList.toggle('active',n===index));
    dots.forEach((dot,n)=>{const active=n===index;dot.classList.toggle('active',active);dot.setAttribute('aria-selected',active?'true':'false')});
  }
  function stop(){if(timer){clearInterval(timer);timer=null}}
  function start(){stop();timer=setInterval(()=>show(index+1),AUTOPLAY)}
  function go(i){show(i);start()}
  prev?.addEventListener('click',()=>go(index-1));next?.addEventListener('click',()=>go(index+1));dots.forEach((dot,n)=>dot.addEventListener('click',()=>go(n)));
  slider.addEventListener('keydown',e=>{if(e.key==='ArrowLeft')go(index-1);if(e.key==='ArrowRight')go(index+1)});
  slider.addEventListener('touchstart',e=>{startX=e.changedTouches[0].clientX;stop()},{passive:true});
  slider.addEventListener('touchend',e=>{const dx=e.changedTouches[0].clientX-startX;if(Math.abs(dx)>45)show(index+(dx<0?1:-1));start()},{passive:true});
  document.addEventListener('visibilitychange',()=>{if(document.hidden)stop();else start()});
  show(0);start();
})();
