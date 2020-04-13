// TOdo : make static ?

class TouchTracker {


  ////////////////////////////
  //    Settings
  //////////////////////////

  // todo : faire un flag pour savoir si le nombre est différent ? 
  // boolean keepA:ive = true;

  ArrayList<TouchPoint> touchPoints = new ArrayList<TouchPoint>();

  boolean isUpdating = false;
  int startUpdateTime = 0;
  int endUpdateTime = 0;



  int  delayBeforeResetingTouchPoint = 150;

  // Find Settings
  public  int closeThreshold = 100;



  // Remove the touch point after a certain delay
  public boolean removeAfterDelay = false;




  ////////////////////////////
  //    CONSTRUCTORS
  //////////////////////////


  public TouchTracker(int maxNumberOftouchPoints ) {
    for (int i =0; i < maxNumberOftouchPoints; i++) {
      touchPoints.add(new TouchPoint(i));
    }
  }

  ////////////////////////////
  //        SETTER
  //////////////////////////

  public TouchPoint UpdateTouchPosition(PVector position, int weight) {

    // initialize update
    if (!isUpdating) {
      startUpdateTime = millis();
      isUpdating = true;
    }

    // todo : loop here to see which one is the closest

    TouchPoint closestTouchPoint = null;
    float closestDist = 300;
    for (int i = 0; i<touchPoints.size(); i++) {
      TouchPoint tp = touchPoints.get(i);

      float currentDist = PVector.dist(position, tp.position);
      if (currentDist < closestDist && currentDist < closeThreshold) {
        closestTouchPoint = tp;
        closestDist = currentDist;
      }
    }

    if (closestTouchPoint == null) {
      println("AssignNewTouchPoint");
      return AssignNewTouchPoint(position, weight);
    } else {
      print("update " );
      print(closestTouchPoint.fingerId);
      print("  " );
      println(closestTouchPoint.state);

      closestTouchPoint.Update(position, weight);
      return closestTouchPoint;
    }
  }


  TouchPoint AssignNewTouchPoint(PVector position, int weight) {
    // todo : assigner le nouvel ID, a commecner par le preier
    // Looper et voir parmi lequel des points non actif est celui qui  été updaté le plus longtemps.

    // We loop in the previosu touch points to see which one inactive was the closest
    TouchPoint closestTouchPoint = null;
    float closestDist = 300;
    for (int i = 0; i<touchPoints.size(); i++) {
      TouchPoint tp = touchPoints.get(i);
      if (!tp.isActive()) {
        float currentDist = PVector.dist(position, tp.position);
        if (currentDist < closestDist && currentDist < closeThreshold * 2) { // see if it's in range
          closestTouchPoint = tp;
          closestDist = currentDist;
        }
      }
    }

    // if we didn't find any close touchPoint, then we get the ID of the one that was last updated 
    // TODO : last updated or first updated ? 
    if (closestTouchPoint == null) {
      int lastTimeUpdated = 0;
      for (int i = 0; i<touchPoints.size(); i++) {
        TouchPoint tp = touchPoints.get(i);
        if (!tp.isActive()) {
          if (tp.lastUpdate > lastTimeUpdated) {
            closestTouchPoint = tp;
            lastTimeUpdated = tp.lastUpdate;
          }
        }
      }
    }

    // if we don't see a closest or we 
    if (closestTouchPoint == null) {
      for (int i = 0; i<touchPoints.size(); i++) {
        TouchPoint tp = touchPoints.get(i);
        if (!tp.isActive() && closestTouchPoint == null) {
          closestTouchPoint = tp;
          continue; // we stop all further iterations
        }
      }
    }





    //todo:remove
    if (closestTouchPoint == null) {
      println("ERROOOOOOOOOR");
    } else
      closestTouchPoint.Update(position, weight);
    // assign new fingerID
    AssignFingerID(closestTouchPoint);

    return closestTouchPoint;
  }



  void AssignFingerID(TouchPoint touchPoint) {
    // TODO : cette fonction ne sert a rien.

    int freeFingerId = -1;

    for (int i = 0; i<touchPoints.size(); i++) {
      TouchPoint tp = touchPoints.get(i);
      if (!tp.isActive() ) {
        freeFingerId = tp.fingerId; // reassign id;
        continue; // we stop all further iterations
      }
    }


    if (freeFingerId != -1) {
      touchPoint.NewId(freeFingerId);
    } else {
      println("All finger ID are not available... thsi should not happend");
    }
    //
    //
  }

  // override
  public void UpdateTouchPosition(PVector position) {
    UpdateTouchPosition(position, 1); // by default set touch wight of 1
  }


  public void update() {
    // here save time ?
    // On doit utiliser ça que si on fait du tracking en continu et qu'on utilise removeAfterDelay

    //isUpdating = true;

    EndTouchFlaggedUp();
    EndTouchNotActiveSinceLongTime();
  }

  public void EndTouchFlaggedUp() {
    for (int i = 0; i<touchPoints.size(); i++) {
      touchPoints.get(i).DisableIfUpState();
    }
  }

  public void EndTouchNotActiveSinceLongTime() {
    for (int i = 0; i<touchPoints.size(); i++) {
      TouchPoint tp = touchPoints.get(i);
      if (!tp.hasBeenUpdated ) {
        //  tp.Reset();
      }
    }
  }

  public void EndUpdate() {
    //TODO :   println("Ici on doit cleaner et enlever les blobs qui n'ont pas été update cette frame");
    for (TouchPoint tp : touchPoints) {
      if (tp.isActive()) {
      }
    }

    for (TouchPoint tp : touchPoints) {
      tp.ResetUpdateState(); // Flag up is not updated

      // println("removeAfterDelay");
      // TODO : change this function to check if  removeAfterDelay is enabled and remove after a certain delay and not right away
    }


    if (isUpdating) {
      endUpdateTime = millis();
      isUpdating = false;
    }
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
        if(tmpLoop == index) touchPoint = tp;
        else  tmpLoop++;
      }
    }
    
    if(touchPoint == null) println("no touchpoint found");
      
    return touchPoint;
  }
}
