enum TouchState {
  DOWN, 
    CONTACT, 
    UP, 
    ENDED
}

class TouchPoint {


  int fingerId = -1;

  TouchState state = TouchState.ENDED;
  PVector position = new PVector(0, 0);
  //PVector filteredPosition = new PVector(0,0);

  int weight = 0;


  int lastUpdate = 0;
  int deltaTimeUpdate = 0;

  boolean hasBeenUpdated = false;

  public TouchPoint(int index) {
    fingerId = index;
    // assign a new finger ID
  }


  public void NewId() {
    // todo : here assign new finger ID
  }


  public boolean isActive() {
    return state == TouchState.CONTACT || state == TouchState.DOWN;
  }


  public void Update(PVector newPosition, int newWeight) {

    // calculate time
    int thisUpdate = millis();
    if (state == TouchState.ENDED) lastUpdate = thisUpdate; // We reset the last updated flag

    deltaTimeUpdate = thisUpdate - lastUpdate;
    lastUpdate = millis(); // OR Date d = new Date(); long current = d.getTime()/1000; 



    position = newPosition;
    weight = newWeight;

    // Updating state
    switch(state) {
    case DOWN:
      state = TouchState.CONTACT;
      break;
    case CONTACT:
      state = TouchState.CONTACT;
      break;
    case UP:
      state = TouchState.CONTACT;
      println("Hum, this should not be possible, or it means that the touch was supposed to be deleted. Maybe switch to state CONTACT?");
      break;
    case ENDED:
      state = TouchState.DOWN;
      break;
    }


    hasBeenUpdated = true;
  }


  public void ResetUpdateState() {
    if (isActive() && !hasBeenUpdated)
      state = TouchState.UP;

    hasBeenUpdated =false;
  }

  public void DisableIfUpState() {
    if (state == TouchState.UP) {
      state = TouchState.ENDED;

    }
  }




  public void draw() {
    // here update position

    strokeWeight(1);
    if (state == TouchState.DOWN)   stroke(0, 255, 0);
    if (state == TouchState.CONTACT)   stroke(0, 0, 0);
    if (state == TouchState.UP) {
      stroke(255, 0, 0);
    }

    //if (state != TouchState.ENDED) {
    if (true) {
      text(fingerId, position.x, position.y);
      // fill(col);
      noFill();
      ellipse(position.x, position.y, weight, weight);

      line(position.x, position.y, position.x-10, position.y);
      line(position.x, position.y, position.x+10, position.y);
      line(position.x, position.y, position.x, position.y-10);
      line(position.x, position.y, position.x, position.y+10);
    }

    /*
    // Remove at the end
     if (state == TouchState.UP) {
     state = TouchState.ENDED;
     }
     */
  }

  public void Reset() {
    println("reset");
    state = TouchState.ENDED;
    position = new PVector(-100, -100);
    deltaTimeUpdate  =  0;
  }
}
