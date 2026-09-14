(function(){
  function applyHQBanners(){
    const carousel=document.querySelector('.meeloc-banner-carousel');
    if(!carousel)return false;
    const slides=[...carousel.querySelectorAll('.meeloc-banner-slide')];
    if(slides.length<3)return false;

    const style=document.createElement('style');
    style.id='meeloc-banner-quality-fix';
    style.textContent=`
      .meeloc-banner-carousel{aspect-ratio:1000/365!important;min-height:0!important;background:#fff!important;border-radius:20px!important;}
      .meeloc-banner-slide{background-image:url('assets/meeloc-banners-sheet.jpg')!important;background-repeat:no-repeat!important;background-size:100% 300%!important;background-position-x:center!important;background-color:#fff!important;}
      .meeloc-banner-slide:nth-child(1){background-position-y:0%!important;}
      .meeloc-banner-slide:nth-child(2){background-position-y:50%!important;}
      .meeloc-banner-slide:nth-child(3){background-position-y:100%!important;}
      .meeloc-banner-slide img{display:none!important;}
      @media(max-width:760px){.meeloc-banner-carousel{border-radius:12px!important;}}
    `;
    document.getElementById('meeloc-banner-quality-fix')?.remove();
    document.head.appendChild(style);
    return true;
  }

  if(!applyHQBanners()){
    const observer=new MutationObserver(()=>{if(applyHQBanners())observer.disconnect();});
    observer.observe(document.documentElement,{childList:true,subtree:true});
    setTimeout(()=>observer.disconnect(),5000);
  }
})();
