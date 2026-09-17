import Book from "../../components/sample/Book";

const LibraryPage=()=>{
    /*
    jsx = script + html
    */

    // script
    const books=[
        
            {category:'it',bookName:'java',price:'10,00원'},
            {category:'it',bookName:'java',price:'10,00원'},
            {category:'lang',bookName:'kor',price:'10,00원'},
            {category:'lang',bookName:'eng',price:'10,00원'},
            {category:'essay',bookName:'xxx',price:'10,00원'},
            {category:'essay',bookName:'xxx',price:'10,00원'}
    ];
    // UI Template
    // html 에서 스크립트 변수를 {} 를 이용해서 자유롭게 사용 가능
    return (
        <div>{
            books.filter(book=>book.category==='lang')
                .map((book,idx)=>{
                    return <Book bookName={book.bookName} price={book.price}/>
                })//chaining 문법 
            }
        </div>
    );
    
    
}

export default LibraryPage;