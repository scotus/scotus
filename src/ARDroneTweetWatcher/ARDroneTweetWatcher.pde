/***
   * Copyright (c) 2013 by Greg Riestenberg and others named in
   * CONTRIBUTORS.txt.
   *
   * This file is part of SCOTUS.
   *
   * SCOTUS is free software: you can redistribute it and/or modify
   * it under the terms of the GNU General Public License as published by
   * the Free Software Foundation, either version 3 of the License, or
   * (at your option) any later version.
   *
   * SCOTUS is distributed in the hope that it will be useful,
   * but WITHOUT ANY WARRANTY; without even the implied warranty of
   * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   * GNU General Public License for more details.
   *
   * You should have received a copy of the GNU General Public License
   * along with SCOTUS.  If not, see <http://www.gnu.org/licenses/>.
   *
   ***/

/*
Studying twitter4j based on: 
 
 SimpleTwitterStreaming ( https://github.com/neufuture/SimpleTwitterStream/ )
 Developed by: Michael Zick Doherty
 2011-10-18
 http://neufuture.com
 
 (thanks Michael:)
 
 */
 
 import com.shigeodayo.ardrone.processing.*;

ARDroneForP5 ardrone;

PFont font;

String txt = "";
String who = "";


///////////////////////////// Config your setup here! ////////////////////////////

/// This is where you enter your Oauth info
static String OAuthConsumerKey = "";
static String OAuthConsumerSecret = "";
// This is where you enter your Access Token info
static String AccessToken = "";
static String AccessTokenSecret = "";
// if you enter keywords here it will filter, otherwise it will sample
String keywords[] = {
  "@ScotusDrone fly", "@ScotusDrone go", "@ScotusDrone run", "@ScotusDrone run", "@ScotusDrone activate", "@ScotusDrone engage"
};


///////////////////////////// End Variable Config ////////////////////////////

TwitterStream twitter = new TwitterStreamFactory().getInstance();


void setup() {
  size(640, 480);
  noStroke();
  font = createFont("Helvetica-bold", 22);
  background(0);

  connectTwitter();
  twitter.addListener(listener);
  if (keywords.length==0) twitter.sample();
  else twitter.filter(new FilterQuery().track(keywords));
    ardrone=new ARDroneForP5("192.168.1.1");
  // connect to the AR.Drone
  ardrone.connect();
  // for getting sensor information
  ardrone.connectNav();
  // for getting video informationp
  ardrone.connectVideo();
  // start to control AR.Drone and get sensor and video data of it
  ardrone.start();
}

void draw() {

  fill(0);
  noStroke();
  rect(0, 0, width, height - 110);
 // x = (x + 10)% width;
  for (int i = 0; i< 6; i++)
  {
    fill(255-i*30);
    ellipse(i*10, 20, 10, 10);
  }
    background(204);  
  // getting image from AR.Drone
  // true: resizeing image automatically
  // false: not resizing
  PImage img = ardrone.getVideoImage(true);
  if (img == null)
    return;
  image(img, 0, 0, 640, 480);

  // print out AR.Drone information
  ardrone.printARDroneInfo();

  // getting sensor information of AR.Drone
  float pitch = ardrone.getPitch();
  float roll = ardrone.getRoll();
  float yaw = ardrone.getYaw();
  float altitude = ardrone.getAltitude();
  float[] velocity = ardrone.getVelocity();
  int battery = ardrone.getBatteryPercentage();
  fill(255,255,255);
  String attitude = "pitch:" + pitch + "\nroll:" + roll + "\nyaw:" + yaw + "\naltitude:" + altitude;
  text(attitude, 15, 15);
  String vel = "vx:" + velocity[0] + "\nvy:" + velocity[1];
  text(vel, 15, 100);
  String bat = "battery:" + battery + " %";
  text(bat, 15, 130);
  text("from: @"+ who, 15, 200);
  text("said: "+ txt, 15, 230);
  
  text("TO ACTIVATE:", 15, 292);
 text("TWEET ONE OF THE FOLLOWING:", 15,306);
 text("@ScotusDrone fly",15, 332);
 text("@ScotusDrone go",15, 357);
 text("@ScotusDrone run",15, 380);
 text("@ScotusDrone activate",15, 406);
 text("@ScotusDrone engage",15, 431);
 text("DO NOT SEND THE SAME TWEET TWICE",15, 463);
 
}


/// my dirt test method for displaying tweets
void displayTw (Status s)
{
  
  String time = "";
  
  String where = "";
  who = s.getUser().getScreenName();
  time = s.getCreatedAt().toString();
  txt = s.getText();
  GeoLocation g =s.getGeoLocation();
  if (g!=null)where = g.toString();

  fill(0);
  noStroke();
  rect(0, height- 110, width, height);
    fill(255, 200, 50);
    

  //textFont(font, 40);
 // text("from: @"+ who, 10, height-70);
 //text("from: @"+ who, 10, 200);
 // textSize(20);
  //text("said: "+ txt, 10, height-30);
 // text("said: "+ txt, 20, 230);
 // text("when: "+ time, 10, height-10);
 // text("where: "+ where, 10, height-50);
  delay(1000);
//  if (txt=="ENGAGE:ARdrone"||txt=="engage makeitso"){
//println("Caught you");
//  }
 ardrone.takeOff();
 delay(6000);
 ardrone.landing();
 delay(1000);
 ardrone.reset();
}




//PCのキーに応じてAR.Droneを操作できる．
// controlling AR.Drone through key input
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      ardrone.forward(); // go forward
    } 
    else if (keyCode == DOWN) {
      ardrone.backward(); // go backward
    } 
    else if (keyCode == LEFT) {
      ardrone.goLeft(); // go left
    } 
    else if (keyCode == RIGHT) {
      ardrone.goRight(); // go right
    } 
    else if (keyCode == SHIFT) {
      ardrone.takeOff(); // take off, AR.Drone cannot move while landing
    } 
    else if (keyCode == CONTROL) {
      ardrone.landing();
      // landing
    }
  } 
  else {
    if (key == 's') {
      ardrone.stop(); // hovering
    } 
    else if (key == 'r') {
      ardrone.spinRight(); // spin right
    } 
    else if (key == 'l') {
      ardrone.spinLeft(); // spin left
    } 
    else if (key == 'u') {
      ardrone.up(); // go up
    }
    else if (key == 'd') {
      ardrone.down(); // go down
    }
    else if (key == '1') {
      ardrone.setHorizontalCamera(); // set front camera
    }
    else if (key == '2') {
      ardrone.setHorizontalCameraWithVertical(); // set front camera with second camera (upper left)
    }
    else if (key == '3') {
      ardrone.setVerticalCamera(); // set second camera
    }
    else if (key == '4') {
      ardrone.setVerticalCameraWithHorizontal(); //set second camera with front camera (upper left)
    }
    else if (key == '5') {
      ardrone.toggleCamera(); // set next camera setting
    }
//    else if (key == 'o'){
//      ardrone.takeOff();
//      delay(5000);
//      ardrone.landing();
//      delay(1000);
//      ardrone.reset();
//    }
  }
}



// Initial connection
void connectTwitter() {
  twitter.setOAuthConsumer(OAuthConsumerKey, OAuthConsumerSecret);
  AccessToken accessToken = loadAccessToken();
  twitter.setOAuthAccessToken(accessToken);
}


// Loading up the access token
private static AccessToken loadAccessToken() {
  return new AccessToken(AccessToken, AccessTokenSecret);
}




// This listens for new tweet
StatusListener listener = new StatusListener() {
  
  public void onStatus(Status status) {
    //println("-"+" @" + status.getUser().getScreenName() + " - " + status.getText());
    displayTw(status);
  }

  public void onDeletionNotice(StatusDeletionNotice statusDeletionNotice) {
    //System.out.println("Got a status deletion notice id:" + statusDeletionNotice.getStatusId());
  }
  public void onTrackLimitationNotice(int numberOfLimitedStatuses) {
    // System.out.println("Got track limitation notice:" + numberOfLimitedStatuses);
  }
  public void onScrubGeo(long userId, long upToStatusId) {
    //System.out.println("Got scrub_geo event userId:" + userId + " upToStatusId:" + upToStatusId);
  }

  public void onException(Exception ex) {
    ex.printStackTrace();
  }
  
  public void onStallWarning(StallWarning warning){
  }
};






