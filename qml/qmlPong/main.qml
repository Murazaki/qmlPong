import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    id: window

    width: 500
    height: 500

    onWidthChanged: width = (width>main.width)?main.width:width;
    onHeightChanged: height = (height>main.height)?main.height:height;

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 5

        text:player1.score + " - " + player2.score
        font.pointSize: 20
    }

    Rectangle {
        id: main
        width: 360
        height: 360

        border.width: 1
        border.color: "black"

        anchors.centerIn: parent

        property double initSpeed: 5
        property double angle: Math.PI/4
        property double speed: initSpeed
        property int advantage: 1

        focus: true

        function checkCollide() {
                if((ball.x <= player1.x + player1.width) &
                   (ball.y + ball.height/2 >= player1.y) &
                   (ball.y + ball.height/2 <= player1.y + player1.height) &
                   (main.speed < 0)) {
                    console.log("colliding with player 1 !");
                    main.speed = -main.speed; // On inverse la direction
                    main.speed += 0.1;
                    main.angle = (ball.y + ball.height/2 - (player1.y + player1.height/2))*Math.PI/(2*player1.height);
                }
                else if((ball.x >= player2.x) &
                        (ball.y + ball.height/2 >= player2.y) &
                        (ball.y + ball.height/2 <= player2.y + player2.height) &
                        (main.speed > 0)) {
                    console.log("colliding with player 2 !");
                    main.speed += 0.1;
                    main.speed = -main.speed; // On inverse la direction
                    main.angle = -(ball.y + ball.height/2 - (player2.y + player2.height/2))*Math.PI/(2*player2.height);
                }
                else if((ball.y <= 0) &
                        (((main.angle < 0) & (main.speed > 0)) |
                         ((main.angle > 0) & (main.speed < 0)))) {
                    console.log("colliding with upper wall !");
                    main.angle = -main.angle;
                }
                else if((ball.y + ball.height >= main.height) &
                        (((main.angle > 0) & (main.speed > 0)) |
                         ((main.angle < 0) & (main.speed < 0)))) {
                    console.log("colliding with bottomer wall !");
                    main.angle = -main.angle;
                }
                else if(ball.x <= 0) {
                    console.log("Player 1 lose !");
                    player2.score++;
                    ballMove.stop();
                    ball.advPlayer2();
                }
                else if(ball.x + ball.width >= main.width) {
                    console.log("Player 2 lose !");
                    player1.score++;
                    ballMove.stop();
                    ball.advPlayer1();
                }

        }

        Rectangle {
            id: player1

            property int score: 0

            Behavior on y { PropertyAnimation{ duration: ballMove.interval } }

            width: 0.01 * parent.width
            height: 0.1 * parent.height
            color: "blue"
            x: 0.02 * parent.width
            y: (parent.height - height)/2
        }

        Rectangle {
            id: player2

            property int score: 0

            Behavior on y { PropertyAnimation{ duration: ballMove.interval } }

            width: 0.01 * parent.width
            height: 0.1 * parent.height
            color : "red"
            x: (1 - 0.02) * parent.width
            y: (parent.height - height)/2
        }

        Rectangle {
            id: ball

            function advPlayer1() {
                x = player1.x + player1.width + 1;
                y = player1.y + player1.height/2 - ball.height/2;
                main.speed = main.initSpeed;
                main.angle = Math.PI/4;
                main.advantage = 1;
            }

            function advPlayer2() {
                x = player2.x - ball.width - 1;
                y = player2.y + player2.height/2 - ball.height/2;
                main.speed = -main.initSpeed;
                main.angle = -Math.PI/4;
                main.advantage = 2;
            }

            Behavior on x { PropertyAnimation{ duration: ballMove.interval } }
            Behavior on y { PropertyAnimation{ duration: ballMove.interval } }

            width: 0.01 * (parent.width+parent.height)/2
            radius: width/2
            height: width

            color: "black"

            onXChanged: main.checkCollide();
            onYChanged: main.checkCollide();

            Component.onCompleted: advPlayer1();
        }

        Timer {
            id: ballMove
            interval: 10
            repeat: true
            onTriggered: {
                ball.x = ball.x + main.speed*Math.cos(main.angle);
                ball.y = ball.y + main.speed*Math.sin(main.angle);

                console.log("speed :" + main.speed + "; angle :" + main.angle + "; x :" + ball.x + "; y :" + ball.y + "; cos(angle) :" + Math.cos(main.angle) + "; sin(angle) :" + Math.sin(main.angle));
            }
        }

        Keys.onPressed: {
            if (event.key == Qt.Key_Z) {
                if(!ballMove.running & (main.advantage == 1))
                    ballMove.running = true;
                player1.y = ((player1.y - 2*Math.abs(speed)< 0)?0:(player1.y - 2*Math.abs(speed)));
            }
            else if (event.key == Qt.Key_S) {
                if(!ballMove.running & (main.advantage == 1))
                    ballMove.running = true;
                player1.y = ((player1.y + 2*Math.abs(speed) > main.height - player1.height)?(main.height - player1.height):(player1.y + 2*Math.abs(speed)));
            }
            else if (event.key == Qt.Key_Up) {
                if(!ballMove.running & (main.advantage == 2))
                    ballMove.running = true;
                player2.y = ((player2.y - 2*Math.abs(speed) < 0)?0:(player2.y - 2*Math.abs(speed)));
            }
            else if (event.key == Qt.Key_Down) {
                if(!ballMove.running & (main.advantage == 2))
                    ballMove.running = true;
                player2.y = ((player2.y + 2*Math.abs(speed) > main.height - player2.height)?(main.height - player2.height):(player2.y + 2*Math.abs(speed)));
            }
        }
    }

}
