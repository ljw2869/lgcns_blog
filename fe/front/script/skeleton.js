const container=document.querySelector('#card-container');

const showSkeletonUI=()=>{
    console.log(`debug >>> showSkeletonUI call`);
    const skeletons=Array.from({length:6},renderSkeletonCard).join('');
    console.log(`debug >>> skeletons `,skeletons);
    container.innerHTML=skeletons;
}

const renderSkeletonCard=()=>{
    //데이터는 오지 않고 틀만 만들어놓음 카드와 동일한 UI의 틀 만듦
    //1.5초 동안
    return `
    <div class ='skeleton-card'>
        <img class='skeleton-img'>
        <div class='skeleton-body'>
            <div class='skeleton-line short'></div>
            <div class='skeleton-line title'></div>
            <div class='skeleton-line text'></div>
            <div class='skeleton-line text'></div>
        </div>
    </div>
    `;
}

const delay=(ms)=>{
    return new Promise((resolve)=>setTimeout(resolve,ms));
}

const renderCard=(item)=>{
    //document.createElement('div')//DOM API를 이용해서 div를 생성할 수 있음 
    //실제 템플릿 뿌려내는 하나의 템플릿
    return `
    <div class ='card'>
        <img class='card-img'src='${item.image}'alt='${item.title}'>
        <div class='card-body'>
        ${item.tag?`<span class='card-tag'>${item.tag}</span>`:""}</div>
        <h3 class='card-title'>${item.title}</h3>
        <p class='card-desc'>${item.description}</p>
        <div class='card-price'>${item.price.toLocaleString()}원</div>
    </div>
    `;
}

const renderCards=(items)=>{
    console.log('debug >>> rendercards call');
    console.log('debug >>> constainer ', container);
    // items.forEach((obj,idx)=>{
    // })
    container.innerHTML=items.map(renderCard).join("");//배열의 요소에서 idx번째의 item의 데이터를 꺼내 조작
    //배열의 인자들을 함수에 전달하는 것은 가능<함수가 함수를 호출>
    //map(renderCard())이게 아님
}

const loadData= async ()=>{
    console.log('1. 데이터 로드 시 스켈레톤 UI를 보여준다....');
    showSkeletonUI();

    const [response] = await Promise.all([
        axios.get('../server/data.json'),
        delay(1500),
    ]);//axios.get()는 promise를 반환함, delay도 promise를 반환함, Promise.all은 배열을 반환함
    console.log('debug >>> data ',response.data);
    renderCards(response.data);
}

loadData();