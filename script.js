function toast(msg){
  const el=document.getElementById('toast');
  if(!el)return;
  el.textContent=msg;el.classList.add('show');
  clearTimeout(window.__toastTimer);
  window.__toastTimer=setTimeout(()=>el.classList.remove('show'),1800);
}

document.addEventListener('click',e=>{
  const toastBtn=e.target.closest('[data-toast]');
  if(toastBtn){e.preventDefault();toast(toastBtn.dataset.toast);}
  const scrollBtn=e.target.closest('[data-scroll]');
  if(scrollBtn){document.querySelector(scrollBtn.dataset.scroll)?.scrollIntoView({behavior:'smooth'});}
});

const search=document.getElementById('searchInput');
if(search){
  const applySearch=()=>{
    const q=search.value.trim().toLowerCase();
    document.querySelectorAll('.searchable-item').forEach(el=>{
      el.style.display=(!q||el.innerText.toLowerCase().includes(q))?'':'none';
    });
  };
  search.addEventListener('input',applySearch);
  document.getElementById('searchBtn')?.addEventListener('click',applySearch);
}

const overlay=document.getElementById('uiOverlay');
const content=document.getElementById('modalContent');
function openModal(html){if(!overlay||!content)return;content.innerHTML=html;overlay.classList.add('open');overlay.setAttribute('aria-hidden','false');}
function closeModal(){if(!overlay)return;overlay.classList.remove('open');overlay.setAttribute('aria-hidden','true');}
document.getElementById('modalClose')?.addEventListener('click',closeModal);
overlay?.addEventListener('click',e=>{if(e.target===overlay)closeModal();});

/* PIN-code serviceability search */
const ACTIVE_PIN='731123';
const ACTIVE_AREA='Dubrajpur, Birbhum';
const pinHost=document.querySelector('.market-top-inner > div:first-child');
function renderPinHeader(){
  if(!pinHost)return;
  const savedPin=localStorage.getItem('meeloc_pin')||ACTIVE_PIN;
  const savedArea=localStorage.getItem('meeloc_area')||(savedPin===ACTIVE_PIN?ACTIVE_AREA:`PIN ${savedPin}`);
  const available=savedPin===ACTIVE_PIN;
  pinHost.innerHTML=`<button id="pincodeBtn" style="border:0;background:transparent;color:#fff;padding:7px 0;font:inherit;font-weight:700;cursor:pointer;text-align:left">📍 Deliver to <b id="deliveryArea">${savedArea} ${savedPin}</b> ⌄</button>`;
  document.body.dataset.serviceable=available?'yes':'no';
  document.getElementById('pincodeBtn')?.addEventListener('click',openPinModal);
}
function openPinModal(){
  const savedPin=localStorage.getItem('meeloc_pin')||ACTIVE_PIN;
  openModal(`<h2>Check Delivery PIN Code</h2>
    <p style="color:#6b7280;margin-top:4px">Enter your 6-digit PIN code to check whether MeeLoc service is available.</p>
    <form class="modal-form" id="pinSearchForm">
      <input id="pinSearchInput" inputmode="numeric" maxlength="6" pattern="[0-9]{6}" value="${savedPin}" placeholder="Enter 6-digit PIN code" required>
      <button type="submit">Check Availability</button>
    </form>
    <div id="pinResult" style="margin-top:14px"></div>
    <p style="font-size:12px;color:#6b7280;margin-top:14px">Current launch service area: Dubrajpur, Birbhum — PIN 731123.</p>`);
  const form=document.getElementById('pinSearchForm');
  form?.addEventListener('submit',e=>{
    e.preventDefault();
    const pin=(document.getElementById('pinSearchInput')?.value||'').trim();
    const result=document.getElementById('pinResult');
    if(!/^\d{6}$/.test(pin)){
      if(result)result.innerHTML='<div style="padding:12px;border-radius:10px;background:#fff3e8;color:#a9490b;font-weight:800">Please enter a valid 6-digit PIN code.</div>';
      return;
    }
    if(pin===ACTIVE_PIN){
      localStorage.setItem('meeloc_pin',pin);
      localStorage.setItem('meeloc_area',ACTIVE_AREA);
      if(result)result.innerHTML='<div style="padding:12px;border-radius:10px;background:#e8f8ef;color:#087443;font-weight:900">✓ Service Available — Dubrajpur, Birbhum</div>';
      document.body.dataset.serviceable='yes';
      setTimeout(()=>{closeModal();renderPinHeader();toast('Service available in Dubrajpur 731123');},850);
    }else{
      localStorage.setItem('meeloc_pin',pin);
      localStorage.setItem('meeloc_area',`PIN ${pin}`);
      if(result)result.innerHTML='<div style="padding:12px;border-radius:10px;background:#fff0ee;color:#b42318;font-weight:900">Service Not Available in Your Area</div>';
      document.body.dataset.serviceable='no';
      renderPinHeader();
    }
  });
}
renderPinHeader();

document.getElementById('loginBtn')?.addEventListener('click',()=>{
  openModal(`<h2>Login / Sign Up</h2><p style="color:#6b7280">Demo UI only. OTP/backend will be connected in the next phase.</p>
  <form class="modal-form" id="loginDemo"><input placeholder="Mobile number" required><button>Continue</button></form>`);
  document.getElementById('loginDemo')?.addEventListener('submit',e=>{e.preventDefault();toast('Login demo — OTP backend not connected yet');closeModal();});
});

let cart=Number(localStorage.getItem('meeloc_demo_cart')||0);
function renderCart(){const c=document.getElementById('cartCount');if(c)c.textContent=cart;}
renderCart();
document.querySelectorAll('.add-btn').forEach(b=>b.addEventListener('click',()=>{
  if(document.body.dataset.serviceable==='no'){
    toast('Service is not available for this PIN code yet');
    openPinModal();
    return;
  }
  cart++;localStorage.setItem('meeloc_demo_cart',String(cart));renderCart();toast(`${b.dataset.product} added to demo cart`);
}));
document.getElementById('cartBtn')?.addEventListener('click',()=>{
  openModal(`<h2>My Cart</h2><div class="cart-line"><span>Demo items</span><b>${cart}</b></div>
  <div class="cart-line"><span>Delivery</span><b>Calculated at checkout</b></div>
  <button class="btn green wide" id="checkoutDemo" style="margin-top:16px">Checkout (Demo)</button>`);
  document.getElementById('checkoutDemo')?.addEventListener('click',()=>toast('Checkout UI comes in the next step'));
});

document.querySelectorAll('form.demo-form').forEach(f=>{
  f.addEventListener('submit',e=>{
    e.preventDefault();
    const dest=f.dataset.demoRedirect;
    toast('Demo registration submitted successfully');
    if(dest)setTimeout(()=>location.href=dest,700);
  });
});
