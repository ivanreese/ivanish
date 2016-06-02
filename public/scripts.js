(function(){var e,a,n,r;n=!1,n&&console.log("Performance --------------------"),e=2*Math.PI,a=function(e,a,n){return null==a&&(a=0),null==n&&(n=1),Math.min(1,Math.max(0,e))},r=function(e,n,r,l,o,t){return null==n&&(n=0),null==r&&(r=1),null==l&&(l=0),null==o&&(o=1),null==t&&(t=!1),n===r?l:(t&&(e=a(e,n,r)),e-=n,e/=r-n,e*=o-l,e+=l)},function(){var e,a,r,l,o,t,i,d,b;for(e=!1,d=e?2147483647:2147483647*Math.random()|0,window.randTableSize=4096,b=function(e,a,n){var r;return r=n[e],n[e]=n[a],n[a]=r},n&&(o=performance.now()),window.randTable=function(){i=[];for(var e=0;0<=randTableSize?e<randTableSize:e>randTableSize;0<=randTableSize?e++:e--)i.push(e);return i}.apply(this),r=0,a=l=0,t=randTableSize;t>=0?t>l:l>t;a=t>=0?++l:--l)r=(r+d+randTable[a])%randTableSize,b(a,r,randTable);return n?console.log((performance.now()-o).toPrecision(4)+"  Table"):void 0}(),ready(function(){var a,r,l,o,t,i,d,b,T,s,c;return a=Math.random(),r=document.querySelector("canvas.js-bio"),null!=r&&"none"!==window.getComputedStyle(r).display?(l=r.getContext("2d"),c=0,d=0,i=2,s=document.body.scrollTop+document.body.parentNode.scrollTop,o=100*Math.random()|0,t=function(){return b()},T=function(){var e;return e=document.body.scrollTop+document.body.parentNode.scrollTop,e===s&&requestAnimationFrame(t),s=e},T(),setInterval(T,150),b=function(){var a,t,b,T,s,f,S,u,h,z,p,m,w,g,y,v;for(g=Math.sin(++o/25)/2+.5,z=parseInt(r.parentNode.offsetWidth)*i,c!==z&&(c=r.width=z,d=r.height=parseInt(r.parentNode.offsetHeight)*i),l.clearRect(0,0,c,d),n&&(p=performance.now()),h=c/6,s=S=0,w=h;w>=0?w>=S:S>=w;s=w>=0?++S:--S)f=s/h,T=1-f,a=randTable[s%randTableSize],b=randTable[a],m=randTable[b],t=randTable[m],u=randTable[t],m=m/randTableSize*c/5,t=(t/randTableSize*50+170*g+200)%360|0,u=u/randTableSize*10+70,y=Math.cos(a/randTableSize*e)*Math.pow(b/randTableSize,.1)*(m/2+c/2)+c/2|0,v=Math.abs(Math.sin(a/randTableSize*e))*Math.pow(b/randTableSize,1/3)*(m/2+d/2)+d/2|0,l.beginPath(),l.fillStyle="hsla("+t+", 33%, "+u+"%, .04)",l.arc(y,v,m,0,e),l.fill();return n?console.log((performance.now()-p).toPrecision(4)+"  Bio"):void 0}):void 0}),ready(function(){return document.body.removeAttribute("fade-out"),window.addEventListener("popstate",function(){return document.body.removeAttribute("fade-out")}),window.addEventListener("beforeunload",function(){return document.body.setAttribute("fade-out",!0)})}),function(){var e,a,n,l,o,t,i,d,b;return l=document.querySelector("header"),null==l||document.querySelector("#index")?void 0:(l.style.opacity=i=o=1,t=0,e=!1,a=1e-4,n=function(){var e,a;return a=document.body.scrollTop+document.body.parentNode.scrollTop,e=r(a,0,l.offsetHeight,1,-.3),e=e*e*e,e=Math.min(1,Math.max(0,e)),i=e},b=function(){return e=!1,t=(i-o)/5,Math.abs(t)>a?(l.style.opacity=o+=t,d()):void 0},d=function(){return e?void 0:(e=!0,window.requestAnimationFrame(b))},window.addEventListener("scroll",function(){return n(),d()}))}(),ready(function(){var a,l,o,t,i,d;for(t=function(e,a){return(e%a+a)%a},i=document.querySelectorAll("canvas.js-infinite-stars"),d=[],l=0,o=i.length;o>l;l++)a=i[l],"none"!==window.getComputedStyle(a).display?d.push(function(a){var l,o,i,d,b,T,s,c,f,S,u,h,z,p,m,w,g,y,v,M,P,x,C,q,E,L,N;return v=!1,o=a.getContext("2d"),N=0,S=0,b=2,i=0,s=0,w=0,l=0,L=0,y=0,E="",f=null,c=!0,g=0,m=!1,p=!1,h=1,d=function(){return v=!1,M()},x=function(){return v?void 0:(v=!0,requestAnimationFrame(d))},C=function(e){return L+=e.deltaY/20,x()},P=function(e){var a;return a=e.touches.item(0).screenY,L-=(a-g)/10,g=a,x(),e.preventDefault()},q=function(e){return g=e.touches.item(0).screenY},u=function(e){return 38===e.keyCode&&(m=!0),40===e.keyCode&&(p=!0),x()},z=function(e){return 38===e.keyCode&&(m=!1),40===e.keyCode&&(p=!1),x()},x(),window.addEventListener("resize",x),window.addEventListener("wheel",C),window.addEventListener("touchstart",q),window.addEventListener("touchmove",P),window.addEventListener("keydown",u),window.addEventListener("keyup",z),T=function(a,n,r,l){return o.beginPath(),c?(o.fillStyle=l,o.arc(a,n,r,0,e),o.fill()):(o.strokeStyle=l,o.lineWidth=2*r,o.moveTo(a,n-L*b),o.lineTo(a,n),o.stroke())},M=function(){var e,d,u,z,w,g,v,M,P,C,q,E,A,k,I,B,F,H,W,j,G,R,Y,D,J,K,O,Q,U,V,X,Z,$,_,ee,ae,ne,re,le,oe,te,ie,de;if(n&&(console.log(""),ee=performance.now()),p&&!m?l=+h:m&&!p?l=-h:l/=1.1,L+=l,L/=1.1,y+=L*b,Math.abs(L)>.3&&x(),F=parseInt(a.parentNode.offsetWidth)*b,N!==F?(o=a.getContext("2d"),N=a.width=F,S=a.height=parseInt(a.parentNode.offsetHeight)*b,i=Math.sqrt(N*S)/(b/2),s=i/3e3,f=o.createRadialGradient(0,S,0,0,S,Math.sqrt(N*N+S*S)),f.addColorStop(0,"hsl(210, 100%, 8%)"),f.addColorStop(.2,"hsl(250, 60%,16%)"),f.addColorStop(.4,"hsl(250, 40%,6%)"),f.addColorStop(.9,"hsl(330, 40%, 12%)"),f.addColorStop(1,"hsl(10, 90%, 22%)"),o.fillStyle=f,o.fillRect(0,0,N,S),e=1,c=!0):(e=Math.min(1,Math.abs(L/2)),c=!1),o.lineCap="round",J=!0,j=!0,d=!0,W=!0,_=!0,$=!0,k=Math.max(0,r(Math.cos(y/S),1,-2,i/25,1)),A=Math.max(0,r(Math.cos(y/S),1,-2,i/20,1)),q=Math.max(0,r(Math.cos(y/S),1,-2,i/25,1)),E=Math.max(0,r(Math.cos(y/S),1,-2,i/5,1)),B=Math.max(0,r(Math.cos(y/S),1,-2,i/50,1)),I=Math.max(0,r(Math.cos(y/S),1,-2,i/20,1)),J){for(n&&(ae=performance.now()),g=P=0,K=k;K>=0?K>=P:P>=K;g=K>=0?++P:--P)v=g/k,z=1-v,H=randTable[(12345+g)%randTableSize],ie=randTable[H],de=randTable[ie],R=randTable[de],M=randTable[R],w=randTable[M],ie=ie/randTableSize*N|0,de=t(de/randTableSize*S-y*(v/2+.5),S),R=R/randTableSize*120*z*s+20,M=M/randTableSize*30*z+30,H=(H/randTableSize*.015+.008)*e,w=w/randTableSize*30+350,T(ie,de,2*R*b/2,"hsla("+w+", 100%, "+M+"%, "+3*H/4+")"),T(ie,de,3*R*b/2,"hsla("+w+", 100%, "+M+"%, "+H/2+")");n&&console.log((performance.now()-ae).toPrecision(4)+"  redBlobs")}if(j){for(n&&(ae=performance.now()),g=C=0,O=A;O>=0?O>=C:C>=O;g=O>=0?++C:--C)v=g/A,z=1-v,ie=randTable[(g+1234)%randTableSize],de=randTable[ie],R=randTable[de],M=randTable[R],H=randTable[M],ie=ie/randTableSize*N*2/3+1*N/6,de=t(de/randTableSize*S*2/3+1*S/6-y*(z/2+.5),S),R=R/randTableSize*200*s*z+30,M=M/randTableSize*10*v+9,H=(H/randTableSize*.07*z+.05)*e,T(ie,de,R*b/2,"hsla(290, 100%, "+M+"%, "+H+")");n&&console.log((performance.now()-ae).toPrecision(4)+"  purpleBlobs")}if(d){for(n&&(ae=performance.now()),g=G=0,Q=q;Q>=0?Q>=G:G>=Q;g=Q>=0?++G:--G)v=g/q,z=1-v,ie=randTable[(g+123)%randTableSize],de=randTable[ie],R=randTable[de],M=randTable[R],w=randTable[M],ie=ie/randTableSize*N,de=t(de/randTableSize*S-y*(z/5+.5),S),R=R/randTableSize*120*s*v+20,Z=M/randTableSize*40+30,M=M/randTableSize*40*z+10,w=w/randTableSize*50+200,T(ie,de,R*b/2,"hsla("+w+", "+Z+"%, "+M+"%, "+.017*e+")"),T(ie,de,2*R*b/2,"hsla("+w+", "+Z+"%, "+M+"%, "+.015*e+")"),T(ie,de,3*R*b/2,"hsla("+w+", "+Z+"%, "+M+"%, "+.013*e+")");n&&console.log((performance.now()-ae).toPrecision(4)+"  blueBlobs")}if(W){for(n&&(ae=performance.now()),g=le=0,U=E;U>=0?U>=le:le>=U;g=U>=0?++le:--le)v=g/E,ie=randTable[(g+5432)%randTableSize],de=randTable[ie],H=randTable[de],R=randTable[H],ie=ie*N/randTableSize,de=t(de*S/randTableSize-y,S),H=(H/randTableSize*.5+.5)*e,R=R/randTableSize*1.5+.5,T(ie,de,R*b/2,"hsla(300, 25%, 50%, "+H+")");n&&console.log((performance.now()-ae).toPrecision(4)+"  pixelStars")}if(_){for(n&&(ae=performance.now()),g=oe=0,V=B;V>=0?V>=oe:oe>=V;g=V>=0?++oe:--oe)v=g/B,z=1-v,ie=randTable[g%randTableSize],de=randTable[ie],Y=randTable[de],D=randTable[Y],ne=randTable[D],re=randTable[ne],M=randTable[re],u=randTable[M],H=randTable[u],ie=ie*N/randTableSize,de=t(de*S/randTableSize-y*z,S),Y=Y/randTableSize*4+.5,D=D/randTableSize*3+.5,M=M/randTableSize*20+20,H=(H/randTableSize*10*z+.3)*e,u=u/randTableSize*120+200,T(ie,de,Y*b/2,"hsla("+u+", 30%, "+M+"%, "+H+")"),T(ie,de,D*b/2,"hsla(0, 0%, 100%, "+e+")");n&&console.log((performance.now()-ae).toPrecision(4)+"  stars")}if($){for(n&&(ae=performance.now()),g=te=0,X=I;X>=0?X>=te:te>=X;g=X>=0?++te:--te)v=g/I,z=1-v,R=randTable[(g+345)%randTableSize],M=randTable[R],H=randTable[M],u=randTable[H],ie=randTable[u],de=randTable[ie],ie=ie*N/randTableSize,de=t(de*S/randTableSize-y*z,S),R=R/randTableSize*2+1,M=M/randTableSize*20+40,H=(H/randTableSize*1*z+.25)*e,u=u/randTableSize*180+200,T(ie,de,R*R*R*b/2,"hsla("+u+", 70%, "+M+"%, "+H/25+")"),T(ie,de,R*R*b/2,"hsla("+u+", 50%, "+M+"%, "+H/6+")"),T(ie,de,R*b/2,"hsla("+u+", 20%, "+M+"%, "+H+")"),T(ie,de,1*b/2,"hsla("+u+", 100%, 90%, "+1.5*H+")");n&&console.log((performance.now()-ae).toPrecision(4)+"  smallGlowingStars")}return n?(console.log(""),console.log((performance.now()-ee).toPrecision(4)+"  Stars")):void 0}}(a)):d.push(void 0);return d}),ready(function(){var a,l,o,t,i;for(t=document.querySelectorAll("canvas.js-stars"),i=[],l=0,o=t.length;o>l;l++)a=t[l],"none"!==window.getComputedStyle(a).display?i.push(function(a){var l,o,t,i,d,b,T,s,c,f;return T=!1,l=a.getContext("2d"),f=0,b=0,i=2,o=0,d=0,t=function(){return T=!1,s()},c=function(){return T?void 0:(T=!0,requestAnimationFrame(t))},c(),window.addEventListener("resize",c),window.addEventListener("scroll",c),s=function(){var t,T,s,c,S,u,h,z,p,m,w,g,y,v,M,P,x,C,q,E,L,N,A,k,I,B,F,H,W,j,G,R,Y,D,J,K,O,Q,U,V,X,Z,$;if(R=document.body.scrollTop+document.body.parentNode.scrollTop,P=parseInt(a.parentNode.offsetWidth)*i,f!==P&&(l=a.getContext("2d"),f=a.width=P,b=a.height=parseInt(a.parentNode.offsetHeight)*i,o=Math.sqrt(f*b),d=o/3e3),n&&(console.log(""),J=performance.now()),k=!0,q=!0,t=!0,C=!0,D=!0,Y=!0,y=Math.max(0,0|r(R,0,.4*b,o/25,0)),g=Math.max(0,0|r(R,0,.4*b,o/20,0)),m=Math.max(0,0|r(R,0,.4*b,o/25,0)),w=Math.max(0,0|r(R,0,.4*b,o/5,0)),M=Math.max(0,0|r(R,0,.4*b,o/50,0)),v=Math.max(0,0|r(R,0,.4*b,o/20,0)),k){for(n&&(K=performance.now()),S=z=0,I=y;I>=0?I>=z:z>=I;S=I>=0?++z:--z)u=S/y,s=1-u,x=randTable[(12345+S)%randTableSize],Z=randTable[x],$=randTable[Z],L=randTable[$],h=randTable[L],c=randTable[h],Z=Z/randTableSize*f|0,$=$/randTableSize*b-R*u|0,L=L/randTableSize*120*s*d+20,h=h/randTableSize*30*s+30,x=x/randTableSize*.015+.008,c=c/randTableSize*30+350,l.beginPath(),l.fillStyle="hsla("+c+", 100%, "+h+"%, "+x+")",l.arc(Z,$,L,0,e),l.fill(),l.beginPath(),l.fillStyle="hsla("+c+", 100%, "+h+"%, "+3*x/4+")",l.arc(Z,$,2*L,0,e),l.fill(),l.beginPath(),l.fillStyle="hsla("+c+", 100%, "+h+"%, "+x/2+")",l.arc(Z,$,3*L,0,e),l.fill();n&&console.log((performance.now()-K).toPrecision(4)+"  redBlobs")}if(q){for(n&&(K=performance.now()),S=p=0,B=g;B>=0?B>=p:p>=B;S=B>=0?++p:--p)u=S/g,s=1-u,Z=randTable[(S+1234)%randTableSize],$=randTable[Z],L=randTable[$],h=randTable[L],x=randTable[h],Z=Z/randTableSize*f*2/3+1*f/6|0,$=$/randTableSize*b*2/3+1*b/6-R*s|0,L=L/randTableSize*200*d*s+30,h=h/randTableSize*10*u+9,x=x/randTableSize*.07*s+.05,l.beginPath(),l.fillStyle="hsla(290, 100%, "+h+"%, "+x+")",l.arc(Z,$,L,0,e),l.fill();n&&console.log((performance.now()-K).toPrecision(4)+"  purpleBlobs")}if(t){for(n&&(K=performance.now()),S=E=0,F=m;F>=0?F>=E:E>=F;S=F>=0?++E:--E)u=S/m,s=1-u,Z=randTable[(S+123)%randTableSize],$=randTable[Z],L=randTable[$],h=randTable[L],c=randTable[h],Z=Z/randTableSize*f|0,$=$/randTableSize*b-R*s|0,L=L/randTableSize*120*d*s+20,G=h/randTableSize*40+30,h=h/randTableSize*40*s+10,c=c/randTableSize*50+200,l.beginPath(),l.fillStyle="hsla("+c+", "+G+"%, "+h+"%, 0.017)",l.arc(Z,$,L,0,e),l.fill(),l.beginPath(),l.fillStyle="hsla("+c+", "+G+"%, "+h+"%, 0.015)",l.arc(Z,$,2*L,0,e),l.fill(),l.beginPath(),l.fillStyle="hsla("+c+", "+G+"%, "+h+"%, 0.013)",l.arc(Z,$,3*L,0,e),l.fill();n&&console.log((performance.now()-K).toPrecision(4)+"  blueBlobs")}if(C){for(n&&(K=performance.now()),S=U=0,H=w;H>=0?H>=U:U>=H;S=H>=0?++U:--U)u=S/w,Z=randTable[(S+5432)%randTableSize],$=randTable[Z],x=randTable[$],L=randTable[x],Z=Z*f/randTableSize|0,$=$*b/randTableSize-R|0,x=x/randTableSize*.5+.5,L=L/randTableSize*1.5+.5,l.beginPath(),l.fillStyle="hsla(300, 25%, 50%, "+x+")",l.arc(Z,$,L,0,e),l.fill();n&&console.log((performance.now()-K).toPrecision(4)+"  pixelStars")}if(D){for(n&&(K=performance.now()),S=V=0,W=M;W>=0?W>=V:V>=W;S=W>=0?++V:--V)u=S/M,s=1-u,Z=randTable[S%randTableSize],$=randTable[Z],N=randTable[$],A=randTable[N],O=randTable[A],Q=randTable[O],h=randTable[Q],T=randTable[h],x=randTable[T],Z=Z*f/randTableSize|0,$=$*b/randTableSize-R*s|0,N=N/randTableSize*4+.5,A=A/randTableSize*3+.5,h=h/randTableSize*20+20,x=x/randTableSize*10*s+.3,T=T/randTableSize*120+200,l.beginPath(),l.fillStyle="hsla("+T+", 30%, "+h+"%, "+x+")",l.arc(Z,$,N,0,e),l.fill(),l.beginPath(),l.fillStyle="hsla(0, 0%, 100%, 1)",l.arc(Z,$,A,0,e),l.fill();n&&console.log((performance.now()-K).toPrecision(4)+"  stars")}if(Y){for(n&&(K=performance.now()),S=X=0,j=v;j>=0?j>=X:X>=j;S=j>=0?++X:--X)u=S/v,s=1-u,L=randTable[(S+345)%randTableSize],h=randTable[L],x=randTable[h],T=randTable[x],Z=randTable[T],$=randTable[Z],Z=Z*f/randTableSize|0,$=$*b/randTableSize-R*s|0,L=L/randTableSize*2+1,h=h/randTableSize*20+40,x=x/randTableSize*1*s+.25,T=T/randTableSize*180+200,l.beginPath(),l.fillStyle="hsla("+T+", 70%, "+h+"%, "+x/25+")",l.arc(Z,$,L*L*L,0,e),l.fill(),l.beginPath(),l.fillStyle="hsla("+T+", 50%, "+h+"%, "+x/6+")",l.arc(Z,$,L*L,0,e),l.fill(),l.beginPath(),l.fillStyle="hsla("+T+", 20%, "+h+"%, "+x+")",l.arc(Z,$,L,0,e),l.fill(),l.beginPath(),l.fillStyle="hsla("+T+", 100%, 90%, "+1.5*x+")",l.arc(Z,$,1,0,e),l.fill();n&&console.log((performance.now()-K).toPrecision(4)+"  smallGlowingStars")}return n?(console.log(""),console.log((performance.now()-J).toPrecision(4)+"  Stars")):void 0}}(a)):i.push(void 0);return i})}).call(this);