pragma solidity >=0.4.22 <0.6.0;

contract SimpleOrderBook{

    uint spread; //there is no float in solidity, what should I do?


//**********************************************//
//Every order has some attributes:
    struct OrderStruct
    {
        address Sender;
        uint Price;
        uint Volume;
        uint Indentifier;
    }

//**********************************************//
    OrderStruct[] public BuyList;  //The array that contains Bid OrderStructs
    OrderStruct[] public SellList; //The array that contains Ask OrderStructs


function exchange ( uint[] a, uint i, uint j ) private returns (bool success){
    uint t = a[i];
    a[i] = a[j];
    a[j] = t;
}

function less (uint i, uint j) private returns (bool success){
    if (j<i) {return true;}
}

function sink (uint[] a ,uint k, uint n ) private {
    while (2*k <= n){
        uint j = 2*k;
        uint jj = j-1;
        if (j <n && SimpleOrderBook.less (a[jj], a[jj+1])) {jj++;}
        if (!SimpleOrderBook.less (a[k-1], a[jj])) {break;}
        SimpleOrderBook.exchange (a,k-1,jj);
        k=j;
    }
}

function sink2 (uint[] a ,uint k, uint n ) private {
    while (2*k <= n){
        uint j = 2*k;
        uint jj = j-1;
        if (j <n && !SimpleOrderBook.less (a[jj], a[jj+1])) {jj++;}
        if (SimpleOrderBook.less (a[k-1], a[jj])) {break;}
        SimpleOrderBook.exchange (a,k-1,jj);
        k=j;
    }
}


function sort (uint[] a) public {
    uint N = a.length;
    for (uint k =N/2; k >= 1; k--){
        SimpleOrderBook.sink(a,k,N);
    }
    while (N > 1){
        SimpleOrderBook.exchange (a, 0, N-1);
        N--;
        SimpleOrderBook.sink (a, 1, N);

    }


}


function minsort (uint[] a) public {
    uint N = a.length;
    for (uint k =N/2; k >= 1; k--){
        SimpleOrderBook.sink2(a,k,N);
    }
    while (N > 1){
        SimpleOrderBook.exchange (a, 0, N-1);
        N--;
        SimpleOrderBook.sink2 (a, 1, N);

    }


}


function exchange (uint[] a ) public returns (bool success){
    uint N = a.length;
    for (uint k =1/2; k >= 1; k--){


    }

}




}
    
