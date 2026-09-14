function toast(msg){const t=document.getElementById('toast');if(!t)return;t.textContent=msg;t.classList.add('show');clearTimeout(window.__at);window.__at=setTimeout(()=>t.classList.remove('show'),1800)}
const panels=[...document.querySelectorAll('.section-panel')];const navBtns=[...document.querySelectorAll('.side-nav button[data-section]')];
function showSection(id){panels.forEach(p=>p.classList.toggle('active',p.id===id));navBtns.forEach(b=>b.classList.toggle('active',b.dataset.section===id));window.scrollTo({top:0,behavior:'smooth'})}
navBtns.forEach(b=>b.addEventListener('click',()=>showSection(b.dataset.section)));document.querySelectorAll('[data-section-jump]').forEach(b=>b.addEventListener('click',()=>showSection(b.dataset.sectionJump)));
document.querySelectorAll('[data-toast]').forEach(b=>b.addEventListener('click',()=>toast(b.dataset.toast)));
document.querySelectorAll('.switch').forEach(s=>s.addEventListener('click',()=>{s.classList.toggle('on');toast('Setting updated in demo')}));
document.getElementById('logoutBtn')?.addEventListener('click',()=>{localStorage.removeItem('meeloc_admin_demo');location.href='index.html'});
const q=document.getElementById('globalSearch');q?.addEventListener('input',()=>{const term=q.value.trim().toLowerCase();document.querySelectorAll('tbody tr').forEach(r=>{r.style.display=(!term||r.innerText.toLowerCase().includes(term))?'':'none'})});

/* Generic admin buttons */
document.addEventListener('click',e=>{
  const b=e.target.closest('button');if(!b)return;
  const text=b.innerText.trim();
  if(b.dataset.section||b.id==='logoutBtn'||b.dataset.toast)return;
  if(text==='Refresh Dashboard'){toast('Dashboard refreshed');return;}
  if(text.includes('Export')){downloadDemoCsv(text);return;}
  if(text.includes('Download Report')){downloadDemoCsv('MeeLoc Report');return;}
  if(text.includes('Add PIN')||text.includes('Add New PIN')){addPinDemo();return;}
  if(text.includes('Add Store')){addStoreDemo();return;}
  if(text.includes('Add Rider')){addRiderDemo();return;}
  if(text.includes('Create Banner')){toast('Banner creator opened in demo');return;}
  if(text.includes('Save Settings')){toast('Commission & fee settings saved');return;}
  if(text.includes('Approve')){setStatus(b,'Approved','green');return;}
  if(text.includes('Reject')){setStatus(b,'Rejected','red');return;}
  if(text.includes('Suspend')){setStatus(b,'Suspended','red');return;}
  if(text.includes('Disable')){setPinStatus(b,'Service Disabled','red');return;}
  if(text.includes('Activate')){setPinStatus(b,'Service Active','green');return;}
  if(text==='Open'||text==='Track'||text==='Invoice'||text==='View'||text==='Review'||text==='Edit'){toast(`${text} action opened in demo`);return;}
  if(text.includes('Add Global Category')){toast('Global category creator opened');return;}
  if(text==='Configure'){toast('Configuration panel opened');return;}
});
function setStatus(btn,label,color){const row=btn.closest('tr')||btn.closest('.quick-item');const status=row?.querySelector('.badge');if(status){status.textContent=label;status.className=`badge ${color}`;}btn.disabled=true;toast(`${label} successfully in demo`)}
function setPinStatus(btn,label,color){const card=btn.closest('.pin-card');const badge=card?.querySelector('.badge');if(badge){badge.textContent=label;badge.className=`badge ${color}`;}toast(label)}
function downloadDemoCsv(name){const data='MeeLoc Demo Export\nGenerated from Admin UI\nOrders,Stores,Riders,Products\n';const blob=new Blob([data],{type:'text/csv'});const a=document.createElement('a');a.href=URL.createObjectURL(blob);a.download=(name||'meeloc-export').toLowerCase().replace(/[^a-z0-9]+/g,'-')+'.csv';a.click();URL.revokeObjectURL(a.href);toast('Demo export downloaded')}
function addPinDemo(){const pin=prompt('Enter 6-digit PIN code');if(!pin)return;if(!/^\d{6}$/.test(pin)){toast('Enter a valid 6-digit PIN');return;}const grid=document.querySelector('#pins .pin-grid');if(!grid){toast('Open PIN Serviceability first');return;}const card=document.createElement('div');card.className='pin-card';card.innerHTML=`<strong>${pin}</strong><p>New MeeLoc service area</p><span class="badge orange">Coming Soon</span><div style="margin-top:12px" class="row-actions"><button class="mini-btn">Edit</button><button class="mini-btn ok">Activate</button></div>`;grid.insertBefore(card,grid.lastElementChild);toast(`PIN ${pin} added`)}
function addStoreDemo(){const name=prompt('Enter store name');if(!name)return;const tbody=document.querySelector('#stores tbody');if(tbody){const r=document.createElement('tr');r.innerHTML=`<td>${name}</td><td>New Owner</td><td>Grocery</td><td>731123</td><td>0</td><td><span class="badge orange">Pending</span></td><td class="row-actions"><button class="mini-btn ok">Approve</button><button class="mini-btn no">Reject</button></td>`;tbody.prepend(r);toast('Demo store added')}}
function addRiderDemo(){const name=prompt('Enter rider name');if(!name)return;const tbody=document.querySelector('#riders tbody');if(tbody){const r=document.createElement('tr');r.innerHTML=`<td>${name}</td><td>Bike • Pending</td><td>Dubrajpur</td><td>0</td><td>—</td><td><span class="badge orange">Pending Approval</span></td><td class="row-actions"><button class="mini-btn ok">Approve</button><button class="mini-btn no">Reject</button></td>`;tbody.prepend(r);toast('Demo rider added')}}
