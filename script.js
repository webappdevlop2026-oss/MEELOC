
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
    })
  })
}
