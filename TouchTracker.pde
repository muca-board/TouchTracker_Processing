// TOdo : make static ?

class TouchTracker {


  ////////////////////////////
  //    Settings
  //////////////////////////

  // todo : faire un flag pour savoir si le nombre est différent ? 
  // boolean keepA:ive = true;

  ArrayList<TouchPoint> touchPoints = new ArrayList<TouchPoint>();
  ArrayList<TouchPoint> touchPointsUpdated = new ArrayList<TouchPoint>();

  /*
  // Remove the touch point after a certain delay
   public boolean removeAfterDelay = false;
   
   boolean isUpdating = false;
   int startUpdateTime = 0;
   int endUpdateTime = 0;
   
   int  delayBeforeResetingTouchPoint = 150;
   */
  // Find Settings
  public  int closeThreshold = 30;






  int maxTouchPoints = 5; // default 5


  ////////////////////////////
  //    CONSTRUCTORS
  //////////////////////////

  public TouchTracker() {
  }

  public TouchTracker(int maxNumberOftouchPoints ) {
    maxTouchPoints = maxNumberOftouchPoints;
  }

  ////////////////////////////
  //        SETTER
  //////////////////////////


  //TODO : en fait il faudrait feeder tous les points et regarder pour chaque quel est le plus proche 

  public void UpdateTouchPosition(PVector position, int weight) {



    touchPointsUpdated.add(new TouchPoint(position, weight));
  }

  // override
  public void UpdateTouchPosition(PVector position) {
    UpdateTouchPosition(position, 1); // by default set touch wight of 1
  }



  TouchPoint CreateNewTouchPoint(PVector position, int weight) {
    // Find availableID
    int targetid = -1;


    for (int id = 0; targetid == -1 && id < maxTouchPoints; id++) {
      boolean isFree = true; 
      for (int i = 0; i<touchPoints.size(); i++) {
        if (touchPoints.get(i).touchID == id) isFree = false;
      }
      if(isFree) {
        targetid = id;
        continue;
      }
    }
  
  if(targetid == -1){
    println("EEEEEEEEEEEEEEEEEEEEEEEEEEERRRORRRR there is no touchpoint available");
  }

   print("Creating id with ");
    println(targetid);
    //Create TouchPoint
    TouchPoint tp = new TouchPoint(targetid);
    tp.Update(position, weight);
    touchPoints.add(tp);
    return tp;
  }





  public void update() {
    // here save time ?
    // On doit utiliser ça que si on fait du tracking en continu et qu'on utilise removeAfterDelay

    //isUpdating = true;

    //EndTouchFlaggedUp();
    // EndTouchNotActiveSinceLongTime();

    // EndTouchFlaggedUp
  }
  /*
  public void EndTouchFlaggedUp() {
   for (int i = 0; i<touchPoints.size(); i++) {
   //  touchPoints.get(i).DisableIfUpState();
   }
   }
   */


  //REset active state
  public void BeginUpdate() {
    for (TouchPoint tp : touchPoints) {
      tp.hasBeenUpdated = false;
    } 

    touchPointsUpdated.clear(); //  Clear temp TouchPoints
  }

  public void EndUpdate() {

    // Update ALl points
    UpdateAllPoints(); 

    //Remove unused points
    for (int i = touchPoints.size()-1; i >= 0; i--) {
      TouchPoint tp = touchPoints.get(i);
      if (tp.CheckIfShouldDisable()) {
        touchPoints.remove(i);
        println("remove");
        print( i );
      }
    }
  }



  public void UpdateAllPoints() {

    int activeTouchPointsNum = touchPoints.size();
    int updatedTouchPointsNum = touchPointsUpdated.size();


    // CASE 1: There is no active point
    if (touchPoints.isEmpty()) {
      for (TouchPoint tp : touchPointsUpdated) {
        CreateNewTouchPoint(tp.position, tp.weight);
      }
      return;
    }



    // CASE 2: There is the same number of updated points than touch points
    // CASE 3: There is one point removed 
    if (updatedTouchPointsNum <= activeTouchPointsNum) { 

      //   updatedTable:
      //  |  idTouchUpdated   |  targetTouchPoint     | 
      //  |      1            |        5              |


      int updatedTable[] = new int[touchPointsUpdated.size()];

      for (int i = 0; i<touchPointsUpdated.size(); i++) {
        TouchPoint updatedTP = touchPointsUpdated.get(i);


        //TouchPoint closestUpdatedTouchPoint = null;
        //  float closestDist = 100;
        float record = 5000;
        int index = -1;
        // todo : usilier le flag hasBeenUpdated.
        for (int k = 0; k<touchPoints.size(); k++) {
          TouchPoint tp = touchPoints.get(k);

          float currentDist = PVector.dist(updatedTP.position, tp.position);
          if (currentDist < record 
            //  &&  currentDist < closeThreshold 
            //  !tp.hasBeenUpdated
            ) {
            index = k;
            record = currentDist;
          }
        }
        updatedTable[i] = index;
      }


      // TODO : Bug si c'est deux fois le plus proche du meme 
      // APply updated table
      for (int i = 0; i<updatedTable.length; i++) {
        print(i);
        print(":");
        print(updatedTable[i]);
        print("|");

        if (updatedTable[i] == -1) {
          CreateNewTouchPoint(touchPointsUpdated.get(i).position, 
            touchPointsUpdated.get(i).weight);
        } else {
          touchPoints.get(updatedTable[i]).Update(
            touchPointsUpdated.get(i).position, 
            touchPointsUpdated.get(i).weight
            );
        }
      }
      println();

      return;
    }





    // CASE 4: There is one new point


    if (updatedTouchPointsNum > activeTouchPointsNum) { 
      // CASE 2: There is the same number of updated points than touch points
      // CASE 3: There is one point removed 

      //   updatedTable:
      //  |  idTouchUpdated   |  targetTouchPoint     | 
      //  |      1            |        5              |


      int updatedTable[] = new int[touchPointsUpdated.size()];

      for (int i = 0; i<touchPointsUpdated.size(); i++) {
        TouchPoint updatedTP = touchPointsUpdated.get(i);

        //TouchPoint closestUpdatedTouchPoint = null;
        //  float closestDist = 100;
        float record = 5000;
        int index = -1;
        // todo : usilier le flag hasBeenUpdated.
        for (int k = 0; k<touchPoints.size(); k++) {
          TouchPoint tp = touchPoints.get(k);

          float currentDist = PVector.dist(updatedTP.position, tp.position);
          if (currentDist < record 
            && currentDist < closeThreshold 
            //  !tp.hasBeenUpdated
            ) {
            index = k;
            record = currentDist;
          }
        }
        updatedTable[i] = index;
      }

      // APply updated table
      for (int i = 0; i<updatedTable.length; i++) {

        if (updatedTable[i] == -1) {
          CreateNewTouchPoint(
            touchPointsUpdated.get(i).position, 
            touchPointsUpdated.get(i).weight
            );
        } else 
        touchPoints.get(updatedTable[i]).Update(
          touchPointsUpdated.get(i).position, 
          touchPointsUpdated.get(i).weight
          );
        print(i);
        print(":");
        print(updatedTable[i]);
        print("|");
      }
      println();

      return;
    }






    /*
    // initialize update
     if (!isUpdating) {
     startUpdateTime = millis();
     isUpdating = true;
     }
     */
  }


  ////////////////////////////
  //    GETTER
  //////////////////////////


  public int touchCount() { // TODO : would be better as a getter 
    int numOfActiveTouches = 0;
    for (TouchPoint tp : touchPoints) {
      if (tp.isActive()) numOfActiveTouches++;
    }
    return numOfActiveTouches;
  }

  public TouchPoint GetTouch(int index) {
    // retoruner  filtrer en fonction de l'id

    int tmpLoop = 0;
    TouchPoint touchPoint = null;
    for (int i = 0; i<touchPoints.size(); i++) {
      TouchPoint tp = touchPoints.get(i);
      if (tp.isActive() && touchPoint == null) {
        if (tmpLoop == index) touchPoint = tp;
        else  tmpLoop++;
      }
    }

    if (touchPoint == null) println("no touchpoint found");

    return touchPoint;
  }
}
