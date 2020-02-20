pragma solidity >=0.4.22 <0.6.0;

contract SimpleOrderBook{



//**********************************************//
//Every order has some attributes:
    struct OrderStruct
    {
        address Sender;
        uint Price;
        uint Volume;
        //uint Indentifier;
    }

//**********************************************//
    OrderStruct[] public BuyList;  //The array that contains Bid OrderStructs (ascending (incremental))
    OrderStruct[] public SellList; //The array that contains Ask OrderStructs (descending (deccremental) = maxheap)

//**********************************************//

//**************MaxheapSort ***********************************************************//

    function maxheap_siftup () private;
    {
    //this function is called because we insert a new element to the end of the array (also heap) and
    //now it has to be sorted again

    uint k = SellList.length - 1; //k is set to be the last entry of the array(also heap) which is the element that's just added and has to be moved up
    while (k > 0){ //while we havent reached to the top of the heap
        uint p = (k-1)/2; //we need to compute the parent of this last element which is p = (k-1)/2

        if (SellList[k].Price > SellList[p].Price) //if the element is greater than its parent
        {
            OrderStruct temp = SellList[k]; //swap k with its parent
            SellList[k] = SellList[p];
            SellList[p] = OrderStruct;
            k = p; //k moves up one level
        }
        else {break;} //if not the break statement exits the loop (it continues until no element index k is not greater than its parent)
    }
//**********************************************//
    //when we want to remove an element from the heap we remove the root of the heap and add the last item
    //to the root and reorder the heap again
    function maxheap_siftdown () private;

    {
      uint k =0;
      uint leftchild = 2*k + 1;

      while (leftchild < SellList.length){ //as long as the left child is within the array that heap is stored in
        uint max = leftchild;
        uint rightchild = leftchild + 1; //rightchild = 2k+2

        if (rightchild < items.length) //if there is a rightchild, then the right child and left child are compared
        {
            if (SellList[rightchild].Price > SellList[leftchild].Price)
            {
              max++; //now max is set to rightchild, otherwise max remains to be the leftchild
            }
        }


        if (SellList[k].Price < SellList[max].Price) //compares the k item with the max item and if its less they are swapped
        {
            OrderStruct temp = SellList[k]; //swap k with its parent
            SellList[k] = SellList[max];
            SellList[max] = temp;

            k = max; //k is set to max
            leftchild =2*k + 1; //l is recompuetd in preparation for the next iteration
        }
        else{ //if the k item is not greater than the max item, siftdown should stop
            break;
        }



    }

}

//**********************************************//
//the new item will be added to the end of the array list and then the list using the add method
//then sifted up with a call to sift up method
    function maxheap_insert (address _sender, uint _price, uint _volume) public
    {
        var neworder = OrderStruct(_sender, _price ,_volume);
        SellList.push(neworder);
        siftup ();
    }

//**********************************************//
    function maxheap_delete () returns (address, uint, uint)
    {
     if (SellList.length == 0) { throw; } //the delete function throws exception if the heap is empty
     if (SellList.length == 1){ // if the heap has only one items
        var result = OrderStruct(_sender, _price ,_volume);
        result = SellList[0];
        delete SellList[0]; //the only element of the heap is removed and returned
        return result;
     }

    //if neither of these conditions are true, then there are at least 2 items in the heap and deletion proceeds
    OrderStruct hold = SellList[0]; //the element on the of the heap is placed in the variable called hold
    SellList[0] = iSellListtems[length] -1; //the last elementof the heap is removed and written into the first position
    delete SellList [SellList.length -1];
    siftdown(); //now the siftdown is called
    return (hold.Sender, hold.Price, hold.Volume);

    }
