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

/* Generic demo links/buttons: no dead controls */
document.addEventListener('click',e=>{
  const scrollBtn=e.target.closest('[data-scroll]');
  if(scrollBtn){e.preventDefault();document.querySelector(scrollBtn.dataset.scroll)?.scrollIntoView({behavior:'smooth'});return;}
  const toastBtn=e.target.closest('[data-toast]');
  if(toastBtn){e.preventDefault();toast(toastBtn.dataset.toast);return;}
  const placeholder=e.target.closest('a[href="#"]');
  if(placeholder){e.preventDefault();toast(`${placeholder.textContent.trim()||'This'} section is ready for backend/content connection`);}
});

/* Product/site search */
const search=document.getElementById('searchInput');
if(search){
  const applySearch=()=>{
    const q=search.value.trim().toLowerCase();
    let hits=0;
    document.querySelectorAll('.searchable-item').forEach(el=>{
      const ok=!q||el.innerText.toLowerCase().includes(q);
      el.style.display=ok?'':'none'; if(ok&&q)hits++;
    });
    if(q)toast(hits?`${hits} matching item(s) found`:'No matching demo item found');
  };
  search.addEventListener('input',()=>{if(!search.value.trim())applySearch();});
  document.getElementById('searchBtn')?.addEventListener('click',applySearch);
  search.addEventListener('keydown',e=>{if(e.key==='Enter')applySearch();});
}

/* Category clicks scroll to products and pre-fill search */
document.querySelectorAll('.category-card').forEach(card=>{
  card.addEventListener('click',()=>{
    const name=card.innerText.trim();
    if(search){search.value='';document.querySelectorAll('.searchable-item').forEach(el=>el.style.display='');}
    document.getElementById('products')?.scrollIntoView({behavior:'smooth'});
    toast(`${name} selected — showing local demo products`);
  });
});

/* PIN-code serviceability */
const ACTIVE_PIN='731123';
const ACTIVE_AREA='Dubrajpur, Birbhum';
const pinHost=document.querySelector('.market-top-inner > div:first-child');
function renderPinHeader(){
  if(!pinHost)return;
  const savedPin=localStorage.getItem('meeloc_pin')||ACTIVE_PIN;
  const savedArea=localStorage.getItem('meeloc_area')||(savedPin===ACTIVE_PIN?ACTIVE_AREA:`PIN ${savedPin}`);
  const available=savedPin===ACTIVE_PIN;
  pinHost.innerHTML=`<button id="pincodeBtn" style="border:0;background:transparent;color:#fff;padding:7px 0;font:inherit;font-weight:700;cursor:pointer;text-align:left">📍 Deliver to <b>${savedArea} ${savedPin}</b> ⌄</button>`;
  document.body.dataset.serviceable=available?'yes':'no';
  document.getElementById('pincodeBtn')?.addEventListener('click',openPinModal);
}
function openPinModal(){
  const savedPin=localStorage.getItem('meeloc_pin')||ACTIVE_PIN;
  openModal(`<h2>Check Delivery PIN Code</h2><p style="color:#6b7280;margin-top:4px">Enter your 6-digit PIN code to check MeeLoc availability.</p><form class="modal-form" id="pinSearchForm"><input id="pinSearchInput" inputmode="numeric" maxlength="6" pattern="[0-9]{6}" value="${savedPin}" placeholder="Enter 6-digit PIN code" required><button type="submit">Check Availability</button></form><div id="pinResult" style="margin-top:14px"></div><p style="font-size:12px;color:#6b7280;margin-top:14px">Launch service area: Dubrajpur, Birbhum — PIN 731123.</p>`);
  document.getElementById('pinSearchForm')?.addEventListener('submit',e=>{
    e.preventDefault(); const pin=(document.getElementById('pinSearchInput')?.value||'').trim(); const result=document.getElementById('pinResult');
    if(!/^\d{6}$/.test(pin)){if(result)result.innerHTML='<div style="padding:12px;border-radius:10px;background:#fff3e8;color:#a9490b;font-weight:800">Please enter a valid 6-digit PIN code.</div>';return;}
    if(pin===ACTIVE_PIN){localStorage.setItem('meeloc_pin',pin);localStorage.setItem('meeloc_area',ACTIVE_AREA);document.body.dataset.serviceable='yes';if(result)result.innerHTML='<div style="padding:12px;border-radius:10px;background:#e8f8ef;color:#087443;font-weight:900">✓ Service Available — Dubrajpur, Birbhum</div>';setTimeout(()=>{closeModal();renderPinHeader();toast('Service available in Dubrajpur 731123');},650);}
    else{localStorage.setItem('meeloc_pin',pin);localStorage.setItem('meeloc_area',`PIN ${pin}`);document.body.dataset.serviceable='no';if(result)result.innerHTML='<div style="padding:12px;border-radius:10px;background:#fff0ee;color:#b42318;font-weight:900">Service Not Available in Your Area</div>';renderPinHeader();}
  });
}
renderPinHeader();

/* Login / sign-up demo */
const loginBtn=document.getElementById('loginBtn');
function renderLogin(){
  if(!loginBtn)return;
  const name=localStorage.getItem('meeloc_demo_user');
  if(name)loginBtn.innerHTML=`<span class="account-icon">●</span><span><b>${name}</b><small>My Account</small></span>`;
}
renderLogin();
loginBtn?.addEventListener('click',()=>{
  const current=localStorage.getItem('meeloc_demo_user');
  if(current){openModal(`<h2>My Account</h2><p>Signed in as <b>${current}</b></p><button class="btn green wide" id="ordersDemo">My Orders</button><button class="btn outline wide" id="logoutCustomer" style="margin-top:10px">Log Out</button>`);document.getElementById('ordersDemo')?.addEventListener('click',()=>toast('Order history demo ready'));document.getElementById('logoutCustomer')?.addEventListener('click',()=>{localStorage.removeItem('meeloc_demo_user');closeModal();renderLogin();toast('Logged out');});return;}
  openModal(`<h2>Login / Sign Up</h2><p style="color:#6b7280">Frontend test login. Real OTP will be connected with backend.</p><form class="modal-form" id="loginDemo"><input id="demoName" placeholder="Your name" required><input inputmode="numeric" placeholder="10-digit mobile number" required><button>Continue</button></form>`);
  document.getElementById('loginDemo')?.addEventListener('submit',e=>{e.preventDefault();const name=document.getElementById('demoName').value.trim()||'Customer';localStorage.setItem('meeloc_demo_user',name);closeModal();renderLogin();toast(`Welcome, ${name}`);});
});

/* Cart with working qty/clear/checkout demo */
let cartItems=JSON.parse(localStorage.getItem('meeloc_demo_cart_items')||'[]');
function saveCart(){localStorage.setItem('meeloc_demo_cart_items',JSON.stringify(cartItems));renderCart();}
function renderCart(){const c=document.getElementById('cartCount');if(c)c.textContent=cartItems.length;}
renderCart();
document.querySelectorAll('.add-btn').forEach(b=>b.addEventListener('click',()=>{
  if(document.body.dataset.serviceable==='no'){toast('Service is not available for this PIN code yet');openPinModal();return;}
  cartItems.push(b.dataset.product||'Demo product');saveCart();toast(`${b.dataset.product} added to cart`);
}));
function showCart(){
  const rows=cartItems.length?cartItems.map((x,i)=>`<div class="cart-line"><span>${x}</span><button class="mini-remove" data-remove="${i}" style="border:0;background:#fff0ee;color:#b42318;border-radius:7px;padding:5px 8px;cursor:pointer">Remove</button></div>`).join(''):'<p style="color:#6b7280">Your cart is empty.</p>';
  openModal(`<h2>My Cart</h2>${rows}<div class="cart-line"><span>Total demo items</span><b>${cartItems.length}</b></div><button class="btn green wide" id="checkoutDemo" style="margin-top:16px" ${cartItems.length?'':'disabled'}>Continue to Checkout</button><button class="btn outline wide" id="clearCart" style="margin-top:10px">Clear Cart</button>`);
  content?.querySelectorAll('[data-remove]').forEach(btn=>btn.addEventListener('click',()=>{cartItems.splice(Number(btn.dataset.remove),1);saveCart();showCart();}));
  document.getElementById('clearCart')?.addEventListener('click',()=>{cartItems=[];saveCart();showCart();toast('Cart cleared');});
  document.getElementById('checkoutDemo')?.addEventListener('click',showCheckout);
}
function showCheckout(){
  openModal(`<h2>Checkout</h2><form class="modal-form" id="checkoutForm"><input placeholder="Full delivery address" required><select style="padding:13px;border:1px solid #dfe5e8;border-radius:10px"><option>Cash on Delivery</option><option>UPI (Demo)</option></select><button>Place Demo Order</button></form>`);
  document.getElementById('checkoutForm')?.addEventListener('submit',e=>{e.preventDefault();const id='ML'+Math.floor(100000+Math.random()*899999);cartItems=[];saveCart();openModal(`<h2>Order Placed ✓</h2><p>Your demo order <b>#${id}</b> has been created.</p><p style="color:#6b7280">Store confirmation and real payment will be connected with the backend.</p><button class="btn green wide" id="doneOrder">Done</button>`);document.getElementById('doneOrder')?.addEventListener('click',closeModal);});
}
document.getElementById('cartBtn')?.addEventListener('click',showCart);

/* Registration forms + upload box */
document.querySelectorAll('.upload').forEach(box=>box.addEventListener('click',()=>{
  const input=document.createElement('input');input.type='file';input.accept='image/*';input.onchange=()=>{if(input.files?.[0]){box.innerHTML=`📷<br><b>${input.files[0].name}</b><br><small>Selected for demo upload</small>`;toast('Shop photo selected');}};input.click();
}));
document.querySelectorAll('form.demo-form').forEach(f=>{
  f.addEventListener('submit',e=>{e.preventDefault();const dest=f.dataset.demoRedirect;toast('Registration submitted successfully in demo');if(dest)setTimeout(()=>location.href=dest,650);});
});

/* Seller / Delivery dashboards — make every sidebar and quick control responsive in demo */
const dash=document.querySelector('.dash');
if(dash){
  const main=document.querySelector('.dash-main');
  const dashboardHTML=main?.innerHTML||'';
  const isSeller=document.querySelector('.sidebar.orange')!==null;
  const sectionTemplates={
    'My Orders':`<div class="dash-top"><h1>My Orders</h1><a class="btn green" href="index.html">Storefront</a></div><section class="panel"><h2>Active & Past Orders</h2><table class="table"><tr><th>Order</th><th>Status</th><th>Action</th></tr><tr><td>#ML100245</td><td><span class="pill new">Active</span></td><td><button class="mini-btn" data-dash-action="Open order">Open</button></td></tr><tr><td>#ML100240</td><td><span class="pill done">Delivered</span></td><td><button class="mini-btn" data-dash-action="View order">View</button></td></tr></table></section>`,
    'Earnings':`<div class="dash-top"><h1>Earnings</h1></div><div class="stats"><div class="stat green"><div>Today</div><div class="value">₹820</div></div><div class="stat orange"><div>This Week</div><div class="value">₹4,960</div></div><div class="stat blue"><div>This Month</div><div class="value">₹18,240</div></div><div class="stat purple"><div>Pending</div><div class="value">₹620</div></div></div><section class="panel"><h2>Payout History</h2><p>Demo payout report is ready for backend connection.</p><button class="btn green" data-dash-action="Download earnings report">Download Report</button></section>`,
    'Wallet':`<div class="dash-top"><h1>Wallet</h1></div><section class="panel"><h2>Available Balance</h2><div style="font-size:42px;font-weight:900;color:#087443">₹2,460</div><p>Demo wallet balance.</p><button class="btn green" data-dash-action="Withdraw request sent">Request Withdrawal</button></section>`,
    'My Vehicle':`<div class="dash-top"><h1>My Vehicle</h1></div><section class="panel"><h2>Bike • WB45A1234</h2><p>Vehicle status: <span class="pill done">Verified</span></p><button class="btn green" data-dash-action="Vehicle edit form opened">Edit Vehicle</button></section>`,
    'Profile':`<div class="dash-top"><h1>Profile</h1></div><section class="panel"><h2>${isSeller?'Store Owner Profile':'Delivery Partner Profile'}</h2><p>Edit your basic account information in this demo section.</p><button class="btn green" data-dash-action="Profile saved">Save Profile</button></section>`,
    'Support':`<div class="dash-top"><h1>Support</h1></div><section class="panel"><h2>Need Help?</h2><p>Create a demo support request.</p><button class="btn green" data-dash-action="Support ticket created">Create Ticket</button></section>`,
    'Orders':`<div class="dash-top"><h1>Store Orders</h1></div><section class="panel"><h2>Order Management</h2><table class="table"><tr><th>Order</th><th>Customer</th><th>Status</th><th>Action</th></tr><tr><td>#ML100245</td><td>Rohit Das</td><td><span class="pill new">New</span></td><td><button class="mini-btn ok" data-dash-action="Order accepted">Accept</button></td></tr><tr><td>#ML100244</td><td>Priya Sharma</td><td><span class="pill prep">Preparing</span></td><td><button class="mini-btn" data-dash-action="Order marked ready">Ready</button></td></tr></table></section>`,
    'Products':`<div class="dash-top"><h1>Products</h1><button class="btn green" data-dash-action="Add product form opened">+ Add Product</button></div><section class="panel"><h2>Product Catalog</h2><p>320 demo products • Search, edit and stock controls will use the same backend later.</p></section>`,
    'Inventory':`<div class="dash-top"><h1>Inventory</h1></div><section class="panel"><h2>Stock Management</h2><p>Update stock status and quantities.</p><button class="btn green" data-dash-action="Inventory saved">Save Inventory</button></section>`,
    'Customers':`<div class="dash-top"><h1>Customers</h1></div><section class="panel"><h2>Recent Customers</h2><p>Customer list and repeat-order data demo.</p></section>`,
    'Promotions':`<div class="dash-top"><h1>Promotions</h1></div><section class="panel"><h2>Offers & Discounts</h2><button class="btn orange" data-dash-action="Offer created">Create Offer</button></section>`
  };
  document.querySelectorAll('.menu a').forEach(link=>link.addEventListener('click',e=>{
    if(link.getAttribute('href')!=='#')return;
    e.preventDefault();document.querySelectorAll('.menu a').forEach(x=>x.classList.remove('active'));link.classList.add('active');const name=link.innerText.trim();
    if(name==='Dashboard'){if(main)main.innerHTML=dashboardHTML;bindDashActions();return;}
    if(sectionTemplates[name]&&main){main.innerHTML=sectionTemplates[name];bindDashActions();window.scrollTo({top:0,behavior:'smooth'});}else toast(`${name} demo section opened`);
  }));
  function bindDashActions(){document.querySelectorAll('[data-dash-action]').forEach(b=>b.addEventListener('click',()=>toast(b.dataset.dashAction)));document.querySelectorAll('.quick').forEach(q=>{q.style.cursor='pointer';q.addEventListener('click',()=>toast(`${q.innerText.trim()} opened`));});}
  bindDashActions();
}
