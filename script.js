function toast(msg){
  const el=document.getElementById('toast');
  if(!el)return;
  el.textContent=msg;el.classList.add('show');
  clearTimeout(window.__toastTimer);
  window.__toastTimer=setTimeout(()=>el.classList.remove('show'),2000);
}

const overlay=document.getElementById('uiOverlay');
const content=document.getElementById('modalContent');
function openModal(html){if(!overlay||!content){toast('Demo action opened');return;}content.innerHTML=html;overlay.classList.add('open');overlay.setAttribute('aria-hidden','false');}
function closeModal(){if(!overlay)return;overlay.classList.remove('open');overlay.setAttribute('aria-hidden','true');}
document.getElementById('modalClose')?.addEventListener('click',closeModal);
overlay?.addEventListener('click',e=>{if(e.target===overlay)closeModal();});

/* =========================================================
   MEELOC HOMEPAGE: 3 BANNERS, CONTINUOUS AUTO-SLIDE
   Customer -> Seller -> Delivery Partner -> repeat
   ========================================================= */
(function setupMeeLocBannerCarousel(){
  const oldHero=document.querySelector('.market-hero');
  if(!oldHero)return;

  const style=document.createElement('style');
  style.textContent=`
    .meeloc-banner-carousel{position:relative;width:100%;aspect-ratio:1600/584;min-height:280px;overflow:hidden;border-radius:22px;background:#eaf8ef;box-shadow:0 10px 28px rgba(17,24,39,.08)}
    .meeloc-banner-track{position:absolute;inset:0}
    .meeloc-banner-slide{position:absolute;inset:0;opacity:0;transform:translateX(5%);transition:opacity .75s ease,transform .75s ease;pointer-events:none}
    .meeloc-banner-slide.active{opacity:1;transform:translateX(0);pointer-events:auto;z-index:2}
    .meeloc-banner-slide img{width:100%;height:100%;display:block;object-fit:cover;object-position:center}
    .meeloc-banner-link{position:absolute;inset:0;z-index:3;cursor:pointer}
    .meeloc-banner-dots{position:absolute;left:50%;bottom:14px;transform:translateX(-50%);z-index:8;display:flex;gap:8px;background:rgba(255,255,255,.78);padding:7px 10px;border-radius:999px;backdrop-filter:blur(5px)}
    .meeloc-banner-dot{width:9px;height:9px;border:0;border-radius:50%;background:#aab8b0;padding:0;cursor:pointer}
    .meeloc-banner-dot.active{background:#087443;transform:scale(1.25)}
    .meeloc-banner-arrow{position:absolute;top:50%;z-index:8;transform:translateY(-50%);width:42px;height:42px;border:0;border-radius:50%;background:rgba(255,255,255,.86);box-shadow:0 5px 16px rgba(0,0,0,.12);font-size:24px;cursor:pointer;color:#087443}
    .meeloc-banner-prev{left:12px}.meeloc-banner-next{right:12px}
    @media(max-width:760px){.meeloc-banner-carousel{border-radius:14px;min-height:0}.meeloc-banner-arrow{width:34px;height:34px;font-size:20px}.meeloc-banner-dots{bottom:8px;padding:5px 8px}.meeloc-banner-dot{width:7px;height:7px}}
  `;
  document.head.appendChild(style);

  const carousel=document.createElement('section');
  carousel.className='meeloc-banner-carousel';
  carousel.setAttribute('aria-label','MeeLoc promotional banners');
  carousel.innerHTML=`
    <div class="meeloc-banner-track">
      <div class="meeloc-banner-slide active" data-target="#categories" data-kind="customer">
        <img src="assets/banner-customer.jpg" alt="Shop Local Live Better with MeeLoc">
        <a class="meeloc-banner-link" href="#categories" aria-label="Shop Local with MeeLoc"></a>
      </div>
      <div class="meeloc-banner-slide" data-target="seller-register.html" data-kind="seller">
        <img src="assets/banner-seller.svg" alt="Join MeeLoc as a Seller">
        <a class="meeloc-banner-link" href="seller-register.html" aria-label="Register as a MeeLoc seller"></a>
      </div>
      <div class="meeloc-banner-slide" data-target="delivery-register.html" data-kind="delivery">
        <img src="assets/banner-delivery.jpg" alt="Join MeeLoc as a Delivery Partner">
        <a class="meeloc-banner-link" href="delivery-register.html" aria-label="Register as a MeeLoc delivery partner"></a>
      </div>
    </div>
    <button class="meeloc-banner-arrow meeloc-banner-prev" type="button" aria-label="Previous banner">‹</button>
    <button class="meeloc-banner-arrow meeloc-banner-next" type="button" aria-label="Next banner">›</button>
    <div class="meeloc-banner-dots" aria-label="Banner navigation">
      <button class="meeloc-banner-dot active" type="button" aria-label="Customer banner"></button>
      <button class="meeloc-banner-dot" type="button" aria-label="Seller banner"></button>
      <button class="meeloc-banner-dot" type="button" aria-label="Delivery banner"></button>
    </div>`;

  oldHero.replaceWith(carousel);

  const slides=[...carousel.querySelectorAll('.meeloc-banner-slide')];
  const dots=[...carousel.querySelectorAll('.meeloc-banner-dot')];
  let index=0;
  let timer;
  const interval=4500;

  function show(i){
    index=(i+slides.length)%slides.length;
    slides.forEach((s,n)=>s.classList.toggle('active',n===index));
    dots.forEach((d,n)=>d.classList.toggle('active',n===index));
  }
  function start(){clearInterval(timer);timer=setInterval(()=>show(index+1),interval);}
  function move(delta){show(index+delta);start();}

  carousel.querySelector('.meeloc-banner-prev').addEventListener('click',()=>move(-1));
  carousel.querySelector('.meeloc-banner-next').addEventListener('click',()=>move(1));
  dots.forEach((d,n)=>d.addEventListener('click',()=>{show(n);start();}));
  carousel.addEventListener('mouseenter',()=>clearInterval(timer));
  carousel.addEventListener('mouseleave',start);

  carousel.querySelector('a[href="#categories"]')?.addEventListener('click',e=>{
    e.preventDefault();document.querySelector('#categories')?.scrollIntoView({behavior:'smooth'});
  });
  start();
})();

/* Generic controls */
document.addEventListener('click',e=>{
  const scrollBtn=e.target.closest('[data-scroll]');
  if(scrollBtn){e.preventDefault();document.querySelector(scrollBtn.dataset.scroll)?.scrollIntoView({behavior:'smooth'});return;}
  const toastBtn=e.target.closest('[data-toast]');
  if(toastBtn){e.preventDefault();toast(toastBtn.dataset.toast);return;}
  const placeholder=e.target.closest('a[href="#"]');
  if(placeholder){e.preventDefault();toast(`${placeholder.textContent.trim()||'This'} section is being connected`);}
});

/* Search */
const search=document.getElementById('searchInput');
function applySearch(){
  if(!search)return;
  const q=search.value.trim().toLowerCase();let hits=0;
  document.querySelectorAll('.searchable-item').forEach(el=>{const ok=!q||el.innerText.toLowerCase().includes(q);el.style.display=ok?'':'none';if(ok&&q)hits++;});
  if(q)toast(hits?`${hits} matching item(s) found`:'No matching item found');
}
search?.addEventListener('keydown',e=>{if(e.key==='Enter')applySearch();});
document.getElementById('searchBtn')?.addEventListener('click',applySearch);

/* Categories */
document.querySelectorAll('.category-card').forEach(card=>card.addEventListener('click',()=>{
  const name=card.innerText.trim();
  document.getElementById('products')?.scrollIntoView({behavior:'smooth'});
  toast(`${name} selected`);
}));

/* PIN-code serviceability */
const ACTIVE_PIN='731123',ACTIVE_AREA='Dubrajpur, Birbhum';
const pinHost=document.querySelector('.market-top-inner > div:first-child');
function renderPinHeader(){
  if(!pinHost)return;
  const pin=localStorage.getItem('meeloc_pin')||ACTIVE_PIN;
  const area=localStorage.getItem('meeloc_area')||(pin===ACTIVE_PIN?ACTIVE_AREA:`PIN ${pin}`);
  document.body.dataset.serviceable=pin===ACTIVE_PIN?'yes':'no';
  pinHost.innerHTML=`<button id="pincodeBtn" style="border:0;background:transparent;color:#fff;padding:7px 0;font:inherit;font-weight:700;cursor:pointer;text-align:left">📍 Deliver to <b>${area} ${pin}</b> ⌄</button>`;
  document.getElementById('pincodeBtn')?.addEventListener('click',openPinModal);
}
function openPinModal(){
  const saved=localStorage.getItem('meeloc_pin')||ACTIVE_PIN;
  openModal(`<h2>Check Delivery PIN Code</h2><p style="color:#6b7280">Enter your 6-digit PIN code.</p><form class="modal-form" id="pinSearchForm"><input id="pinSearchInput" inputmode="numeric" maxlength="6" value="${saved}" placeholder="Enter PIN code" required><button>Check Availability</button></form><div id="pinResult" style="margin-top:14px"></div>`);
  document.getElementById('pinSearchForm')?.addEventListener('submit',e=>{
    e.preventDefault();const pin=document.getElementById('pinSearchInput').value.trim(),r=document.getElementById('pinResult');
    if(!/^\d{6}$/.test(pin)){r.innerHTML='<b style="color:#b42318">Enter a valid 6-digit PIN.</b>';return;}
    localStorage.setItem('meeloc_pin',pin);
    if(pin===ACTIVE_PIN){localStorage.setItem('meeloc_area',ACTIVE_AREA);r.innerHTML='<b style="color:#087443">✓ Service Available — Dubrajpur, Birbhum</b>';document.body.dataset.serviceable='yes';}
    else{localStorage.setItem('meeloc_area',`PIN ${pin}`);r.innerHTML='<b style="color:#b42318">Service Not Available in Your Area</b>';document.body.dataset.serviceable='no';}
    renderPinHeader();
  });
}
renderPinHeader();

/* Customer login demo */
const loginBtn=document.getElementById('loginBtn');
function renderLogin(){const n=localStorage.getItem('meeloc_demo_user');if(loginBtn&&n)loginBtn.innerHTML=`<span class="account-icon">●</span><span><b>${n}</b><small>My Account</small></span>`;}
renderLogin();
loginBtn?.addEventListener('click',()=>{
  const current=localStorage.getItem('meeloc_demo_user');
  if(current){openModal(`<h2>My Account</h2><p>Signed in as <b>${current}</b></p><button class="btn outline wide" id="logoutCustomer">Log Out</button>`);document.getElementById('logoutCustomer')?.addEventListener('click',()=>{localStorage.removeItem('meeloc_demo_user');location.reload();});return;}
  openModal(`<h2>Login / Sign Up</h2><form class="modal-form" id="loginDemo"><input id="demoName" placeholder="Your name" required><input placeholder="Mobile number" required><button>Continue</button></form>`);
  document.getElementById('loginDemo')?.addEventListener('submit',e=>{e.preventDefault();localStorage.setItem('meeloc_demo_user',document.getElementById('demoName').value.trim()||'Customer');closeModal();location.reload();});
});

/* Cart demo */
let cartItems=JSON.parse(localStorage.getItem('meeloc_demo_cart_items')||'[]');
function saveCart(){localStorage.setItem('meeloc_demo_cart_items',JSON.stringify(cartItems));const c=document.getElementById('cartCount');if(c)c.textContent=cartItems.length;}
saveCart();
document.querySelectorAll('.add-btn').forEach(b=>b.addEventListener('click',()=>{
  if(document.body.dataset.serviceable==='no'){openPinModal();return;}
  cartItems.push(b.dataset.product||'Product');saveCart();toast(`${b.dataset.product||'Product'} added to cart`);
}));
document.getElementById('cartBtn')?.addEventListener('click',()=>{
  const rows=cartItems.length?cartItems.map(x=>`<div class="cart-line"><span>${x}</span></div>`).join(''):'<p>Your cart is empty.</p>';
  openModal(`<h2>My Cart</h2>${rows}<button class="btn green wide" id="checkoutDemo" ${cartItems.length?'':'disabled'}>Checkout</button><button class="btn outline wide" id="clearCart" style="margin-top:10px">Clear Cart</button>`);
  document.getElementById('clearCart')?.addEventListener('click',()=>{cartItems=[];saveCart();closeModal();toast('Cart cleared');});
  document.getElementById('checkoutDemo')?.addEventListener('click',()=>toast('Checkout demo opened'));
});

/* Registration forms & upload */
document.querySelectorAll('.upload').forEach(box=>box.addEventListener('click',()=>{const i=document.createElement('input');i.type='file';i.accept='image/*';i.onchange=()=>{if(i.files?.[0]){box.innerHTML=`📷<br><b>${i.files[0].name}</b><br><small>Selected</small>`;}};i.click();}));
document.querySelectorAll('form.demo-form').forEach(f=>f.addEventListener('submit',e=>{e.preventDefault();toast('Registration submitted successfully');const d=f.dataset.demoRedirect;if(d)setTimeout(()=>location.href=d,650);}));

/* Dashboard demo controls */
document.querySelectorAll('[data-dash-action]').forEach(b=>b.addEventListener('click',()=>toast(b.dataset.dashAction)));
document.querySelectorAll('.quick').forEach(q=>{q.style.cursor='pointer';q.addEventListener('click',()=>toast(`${q.innerText.trim()} opened`));});
