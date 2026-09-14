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

// MeeLoc homepage slider: continuous autoplay + arrows + dots + keyboard + swipe.
(function(){
  const slider=document.querySelector('.hero-slider');
  if(!slider) return;

  const slides=[...slider.querySelectorAll('.slide')];
  const dots=[...slider.querySelectorAll('.dot')];
  const prev=slider.querySelector('.slider-arrow.prev');
  const next=slider.querySelector('.slider-arrow.next');
  if(slides.length<2) return;

  let index=0;
  let timer=null;
  let startX=0;
  const AUTOPLAY=4000;

  function show(i){
    index=(i+slides.length)%slides.length;
    slides.forEach((slide,n)=>slide.classList.toggle('active',n===index));
    dots.forEach((dot,n)=>{
      const active=n===index;
      dot.classList.toggle('active',active);
      dot.setAttribute('aria-selected',active?'true':'false');
    });
  }

  function stop(){
    if(timer){
      clearInterval(timer);
      timer=null;
    }
  }

  function start(){
    stop();
    timer=setInterval(()=>show(index+1),AUTOPLAY);
  }

  function go(i){
    show(i);
    start();
  }

  prev?.addEventListener('click',()=>go(index-1));
  next?.addEventListener('click',()=>go(index+1));
  dots.forEach((dot,n)=>dot.addEventListener('click',()=>go(n)));

  // Keep autoplay running even when the mouse is over the banner.
  slider.addEventListener('keydown',e=>{
    if(e.key==='ArrowLeft') go(index-1);
    if(e.key==='ArrowRight') go(index+1);
  });

  slider.addEventListener('touchstart',e=>{
    startX=e.changedTouches[0].clientX;
    stop();
  },{passive:true});

  slider.addEventListener('touchend',e=>{
    const dx=e.changedTouches[0].clientX-startX;
    if(Math.abs(dx)>45) show(index+(dx<0?1:-1));
    start();
  },{passive:true});

  document.addEventListener('visibilitychange',()=>{
    if(document.hidden) stop();
    else start();
  });

  show(0);
  start();
})();
