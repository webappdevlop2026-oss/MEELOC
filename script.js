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

document.getElementById('loginBtn')?.addEventListener('click',()=>{
  openModal(`<h2>Login / Sign Up</h2><p style="color:#6b7280">Demo UI only. OTP/backend will be connected in the next phase.</p>
  <form class="modal-form" id="loginDemo"><input placeholder="Mobile number" required><button>Continue</button></form>`);
  document.getElementById('loginDemo')?.addEventListener('submit',e=>{e.preventDefault();toast('Login demo — OTP backend not connected yet');closeModal();});
});

let cart=Number(localStorage.getItem('meeloc_demo_cart')||0);
function renderCart(){const c=document.getElementById('cartCount');if(c)c.textContent=cart;}
renderCart();
document.querySelectorAll('.add-btn').forEach(b=>b.addEventListener('click',()=>{
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
