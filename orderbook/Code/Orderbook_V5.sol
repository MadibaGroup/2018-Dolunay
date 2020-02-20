pragma solidity >=0.4.22 <0.6.0;

contract SimpleOrderBook{



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

    array[] items;
//**********************************************//

//**********************************************//

    function siftup () private;
    {
    //this function is called because we insert a new element to the end of the array (also heap) and
    //now it has to be sorted again

    uint k = items.length - 1; //k is set to be the last entry of the array(also heap) which is the element that's just added and has to be moved up
    while (k > 0){ //while we havent reached to the top of the heap
        uint p = (k-1)/2; //we need to compute the parent of this last element which is p = (k-1)/2

        if (items[k] > items[p]) //if the element is greater than its parent
        {
            uint temp = items[k]; //swap k with its parent
            items[k] = items[p];
            items[p] = t;
            k = p; //k moves up one level
        }
        else {break;} //if not the break statement exits the loop (it continues until no element index k is not greater than its parent)
    }
//**********************************************//
    //when we want to remove an element from the heap we remove the root of the heap and add the last item
    //to the root and reorder the heap again
    function siftdown () private;

    {
      uint k =0;
      uint leftchild = 2*k + 1;

      while (leftchild < items.length){ //as long as the left child is within the array that heap is stored in
        uint max = leftchild;
         uint rightchild = leftchild + 1; //rightchild = 2k+2

        if (rightchild < items.length) //if there is a rightchild, then the right child and left child are compared
        {
            if (rightchild > leftchild)
            {
              max++; //now max is set to rightchild, otherwise max remains to be the leftchild
            }
        }


        if (k < max) //compares the k item with the max item and if its less they are swapped
        {
            uint temp = items[k]; //swap k with its parent
            items[k] = items[max];
            items[amx] = t;

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
    function insert (uint item) public
    {
        items.add(item);
        siftup ();
    }
//**********************************************//
    function delete ()
    {
     if (items.length == 0) { throw; } //the delete function throws exception if the heap is empty
     if (items.length == 1){ // if the heap has only one items
        uint result  = items[0];
        delete items[0]; //the only element of the heap is removed and returned
        return result;
     }

    //if neither of these conditions are true, then there are at least 2 items in the heap and deletion proceeds
    uint hold = items[0]; //the element on the of the heap is placed in the variable called hold
    items[0] = items[length] -1; //the last elementof the heap is removed and written into the first position
    delete items [items.length -1];
    siftdown(); //now the siftdown is called
    return hold;
    }
