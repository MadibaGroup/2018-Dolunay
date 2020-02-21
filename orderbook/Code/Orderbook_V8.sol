pragma solidity >=0.4.22 <0.6.0;

contract OrderbookV8{



//**********************************************//
//Every order has some attributes:
    struct OrderStruct
    {
        address Sender;
        uint Price;
        uint Volume;

    }



//**********************************************//
    OrderStruct[] public BuyList;  //The array that contains Bid OrderStructs (ascending (incremental))
    OrderStruct[] public SellList; //The array that contains Ask OrderStructs (descending (deccremental) = maxheap)

//**********************************************//



//******************** submitBid function ********************//
    //submitBid function calls the minheap_insert function
    function submitBid (uint _price, uint _volume ) public returns (bool success) {

        this.minheap_insert( msg.sender, _price, _volume );

    }
//******************** submitask function ********************//
    //submitAsk function calls the maxheap_insert function
    function submitAsk (uint _price, uint _volume ) public returns (bool success) {

        this.maxheap_insert( msg.sender, _price, _volume );

    }

//**********************************************//


//************************************************************************//
//*********************     function modifiers    ************************//
//************************************************************************//




//************************************************************************//
//*********************     auxillary functions    ************************//
//************************************************************************//


//****************   ordertype function  *********************//
    //ordertype order checks if the incoming order is a bid or ask
    function ordertype ( bool _type ) private returns (bool success){

        OrderStruct temp = a[i];    //"!SYNTAX!"
        a[i] = a[j];
        a[p] = temp;
    }


//****************   swap function  *********************//
    //swap function swaps the elements i and j in the array list (i=k, j=p)
    function swap ( OrderStruct[] a, uint i, uint j ) private returns (bool success){

        OrderStruct temp = a[i];    //"!SYNTAX!"
        a[i] = a[j];
        a[p] = temp;
    }



//****************   peek function  *********************//
    //peek function returns the highest priority element
    function peek ( OrderStruct[] a, uint i, uint j ) public returns (address, uint, uint){

        if (a.length == 0) { throw; } //the delete function throws exception if the heap is empty
        return (a[0].Sender, a[0].Price, a[0].Volume);

    }


//************************************************************************//
//*********************     Maxheap (SellList)    ************************//
//************************************************************************//


//*******************  maxheap_heapifyUp () ***************************//
    //this function is called everytime we insert a new element to the end of the array (aka a new sell order is submitted) and
    //now the heap has to be sorted again
    function maxheap_heapifyUp () private;
    {
        uint k = SellList.length - 1;                   //k is set to be the last entry of the array (also heap) which is the element that's just added and has to be moved up
        while (k > 0){                                  //while we havent reached to the top of the heap
            uint p = (k-1)/2;                           //we need to compute the parent of this last element which is p = (k-1)/2
            if (SellList[k].Price >= SellList[p].Price) //if the element is greater than its parent
            {   //"!SYNTAX!"
                this.swap (SellList, k, p)              //swap the element at index k with its parent
                k = p;                                  //k moves up one level
            }
            else {break;}                               //if not the break statement exits the loop (it continues until no element index k is not greater than its parent)
        }
    }
//*******************  maxheap_heapifyDown () ***************************//
    //when we want to remove an element from the heap we remove the root of the heap and add the last item
    //to the root and reorder the heap again
    function maxheap_heapifyDown () private;
    {
        uint k =0;
        uint leftchild = 2*k + 1;
        while (leftchild < SellList.length)
        {                                   //as long as the left child is within the array that heap is stored in
            uint max = leftchild;
            uint rightchild = leftchild + 1;                                     //rightchild = 2k+2

            if (rightchild < items.length)                                       //if there is a rightchild
            {
                if (SellList[rightchild].Price > = SellList[leftchild].Price)    //then the right child and left child are compared
                {
                    max++;                                                       //now max is set to rightchild, otherwise max remains to be the leftchild
                }
            }

        if (SellList[k].Price =< SellList[max].Price)                        //compares the k item with the max item and if k is smaller than its greatest children they are swapped
        {
            //swap k with its greatest children (max)
            //"!SYNTAX!"
            this.swap (SellList, k, max)
            k = max;                                                         //k is set to max
            leftchild =2*k + 1;                                              //l is recompuetd in preparation for the next iteration
        }
        else{                                                               //if the k item is not smaller than the max item, heapifyDown should stop
            break;
            }
        }
    }

//*******************  maxheap_insert () ***************************//
    //the new item will be added to the end of the array list (a sell order is submitted)
    //then heapified up with a call to heapifyUp method
    function maxheap_insert (address _sender, uint _price, uint _volume) public
    {
        OrderStruct neworder = OrderStruct(_sender, _price ,_volume);
        SellList.push(neworder);
        this.maxheap_heapifyUp (); //"!SYNTAX!"
    }

//*******************  maxheap_delete () ***************************//
    //the highest priority item will be removed from the list and is returned by the function
    //then the heap is reordered uising the heapifyDown method
    function maxheap_delete () returns (address, uint, uint)
    {
        if (SellList.length == 0) { throw; }                             //the delete function throws exception if the heap is empty
        if (SellList.length == 1) {                                      // if the heap has only one items
            OrderStruct result = OrderStruct(_sender, _price ,_volume);          //"!SYNTAX!"
            result = SellList[0];
            delete SellList[0];                                          //the only element of the heap is removed and returned "!SYNTAX!"
            return result;
        }

        //if neither of these conditions are true, then there are at least 2 items in the heap and deletion proceeds
        OrderStruct hold = SellList[0]; //the element on the of the heap is placed in the variable called hold
        SellList[0] = SellList[length] -1; //the last elementof the heap is removed and written into the first position
        delete SellList [SellList.length -1];
        maxheap_heapifyDown(); //now the siftdown is called
        return (hold.Sender, hold.Price, hold.Volume);
    }

//************************************************************************//
//*********************     Minheap (BuyList)    ************************//
//************************************************************************//


//*******************  minheap_heapifyUp () ***************************//
    //this function is called everytime we insert a new element to the end of the array (aka a new buy order is submitted) and
    //now the heap has to be sorted again
    function minheap_heapifyUp () private;
    {

        uint k = BuyList.length - 1;                   //k is set to be the last entry of the array(also heap) which is the element that's just added and has to be moved up
        while (k > 0){                                 //while we havent reached to the top of the heap
            uint p = (k-1)/2;                          //we need to compute the parent of this last element which is p = (k-1)/2
            if (BuyList[k].Price < = BuyList[p].Price) //if the element is greater than its parent
            {
                this. swap (BuyList, k, p) //swap k with its parent "!SYNTAX!"
                k = p; //k moves up one level
            }
            else {break;} //if not the break statement exits the loop (it continues until no element index k is not greater than its parent)
        }
    }
//*******************  minheap_heapifyDown () ***************************//
    //when we want to remove an element from the heap we remove the root of the heap and add the last item
    //to the root and reorder the heap again
    function minheap_heapifyDown () private;

    {
        uint k =0;
        uint leftchild = 2*k + 1;
        while (leftchild < BuyList.length){               //as long as the left child is within the array that heap is stored in
            uint min = leftchild;
            uint rightchild = leftchild + 1;              //rightchild = 2k+2

            if (rightchild < items.length)                //if there is a rightchild, then the right child and left child are compared
            {
                if (BuyList[rightchild].Price < BuyList[leftchild].Price)
                {    min++;   }                               //now min is set to rightchild, otherwise min remains to be the leftchild
            }

            if (BuyList[min].Price < = BuyList[k].Price) //compares the k item with the max item and if its less they are swapped
            {
                swap (BuyList, k, min) //swap k with its smaller children
                k = min; //k is set to min
                leftchild =2*k + 1; //l is recompuetd in preparation for the next iteration
            }
            else{ //if k item's smaller childer is not smaller than k item itself, heapifyDown should stop
                break;
            }
        }
    }
//*******************  minheap_insert () ***************************//
    //the new item will be added to the end of the array list (a buy order is submitted)
    //then heapified up with a call to heapifyUp method
    function minheap_insert (address _sender, uint _price, uint _volume) public
    {
        OrderStruct neworder = OrderStruct(_sender, _price ,_volume); //"!SYNTAX!"
        SellList.push(neworder);
        this.minheap_heapifyUp ();                           //"!SYNTAX!"
    }

//*******************  minheap_delete () ***************************//
    //the highest priority item (the smallest bid) will be removed from the list and is returned by the function
    //then the heap is reordered uising the heapifyDown method
    function minheap_delete () returns (address, uint, uint)
    {
        if (BuyList.length == 0) { throw; }                      //the delete function throws exception if the heap is empty
        if (BuyList.length == 1) {                               // if the heap has only one item
            OrderStruct result = OrderStruct(_sender, _price ,_volume);  //"!SYNTAX!"
            result = BuyList[0];
            delete BuyList[0];                                   //the only element of the heap is removed and returned  "!SYNTAX!"
            return result;                                       // "!SYNTAX!"
        }

        //if neither of these conditions are true, then there are at least 2 items in the heap and deletion proceeds
        OrderStruct hold = BuyList[0];                        //the element on the of the heap is placed in the variable called hold "!SYNTAX!"
        BuyList[0] = BuyList[length] -1;                      //the last elementof the heap is removed and written into the first position
        delete BuyList [BuyList.length -1];                   //"!SYNTAX!"
        this.minheap_heapifyDown();                           //now the heapifyDown is called to restore the ordering of the heap "!SYNTAX!"
        return (hold.Sender, hold.Price, hold.Volume);        //"!SYNTAX!"
    }

//************************************************************************//
//************************************************************************//
//************************************************************************//

}
