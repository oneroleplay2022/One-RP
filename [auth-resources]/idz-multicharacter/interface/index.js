let playerChars = {};
let currentIndex = 0;

const newCharCard = document.querySelector("#new-char-card");
const leftButton = document.querySelector("#move-left");
const rightButton = document.querySelector("#move-right");
const deleteButton = document.querySelector("#card-delete")
const charactersAmount = document.querySelector("#chars-amount");
const existingCard = document.querySelector("#player-card");


let emoteKey = "";
let canPress = false
let loaderShowing = false;
window.addEventListener("message", (event) => {
    const eventData = event.data;
    if (eventData.playerCard) {
        console.log("Existing Characters")
        emoteKey = eventData.emoteKey
        canPress = true;
        document.querySelector("#right-blur").style.opacity = "0";
        document.querySelector("#left-blur").style.opacity = "0";       
        newCharCard.style.display = "none";
        leftButton.style.display = "block";
        rightButton.style.display = "block";
        existingCard.style.display = "flex";
        playerChars = JSON.parse(eventData.playerChars);
        const charsAmount = playerChars.length != undefined ? playerChars.length : 1;
        charactersAmount.innerText = "1/" + charsAmount;
        document.querySelector("#blur-circle").style.display = "block";
        currentIndex = 0;
        setPlayerCard(currentIndex);
    }
    if (eventData.newCharMenu) {
        console.log("New Char Menu")
        newCharCard.style.display = "flex";
        existingCard.style.display = "none";
        charactersAmount.innerText = "";
        document.querySelector("#right-blur").style.opacity = "0";
        document.querySelector("#left-blur").style.opacity = "0";
        document.querySelector("#blur-circle").style.display = "none";
        rightButton.classList = "fas fa-caret-square-right";
        leftButton.style.display = "none";
        rightButton.style.display = "none";
        document.querySelector("#failed-mugshot").style.display = "none";
        existingCard.classList.remove("failed");
    }
    if (eventData.failedMugshot) {
        console.log("Failed Mugshot.")
        existingCard.classList.add("failed");
        if (playerChars[currentIndex].charName.includes("Avi Dahari")) {
            document.querySelector("#failed-mugshot").innerHTML = '<img src="https://cdn.discordapp.com/attachments/818375239330299945/896402099095629824/unknown.png">'
        } else {
            document.querySelector("#failed-mugshot").innerHTML = '<i class="fas fa-user"></i>'
        }
        document.querySelector("#failed-mugshot").style.display = "flex";
    }
    if (eventData.successMugshot) {
        console.log("Success Mugshot.")
        document.querySelector("#failed-mugshot").style.display = "none";
        existingCard.classList.remove("failed");
    }
    if (eventData.loader == true) {
        document.querySelector("#loader").style.opacity = "0";
        document.querySelector("#loader").style.display = "block";
        loaderShowing = true
        setTimeout(() => {
            document.querySelector("#loader").style.opacity = "1";
            existingCard.classList.add("failed");
            if (playerChars[currentIndex].charName.includes("Avi Dahari")) {
                document.querySelector("#failed-mugshot").innerHTML = '<img src="https://cdn.discordapp.com/attachments/818375239330299945/896402099095629824/unknown.png">'
            } else {
                document.querySelector("#failed-mugshot").innerHTML = '<i class="fas fa-user"></i>'
            }
            document.querySelector("#failed-mugshot").style.display = "flex";    
        }, 25);

        existingCard.style.filter = "blur(4px)";
    }
    if (eventData.loader == false) {
        document.querySelector("#loader").style.opacity = "0";
        document.querySelector("#loader").style.display = "none";
        document.querySelector("#failed-mugshot").style.display = "none";
        existingCard.classList.remove("failed");    
        loaderShowing = false
        if (eventData.mugshot) {
            existingCard.classList.add("failed");
            if (playerChars[currentIndex].charName.includes("Avi Dahari")) {
                document.querySelector("#failed-mugshot").innerHTML = '<img src="https://cdn.discordapp.com/attachments/818375239330299945/896402099095629824/unknown.png">'
            } else {
                document.querySelector("#failed-mugshot").innerHTML = '<i class="fas fa-user"></i>'
            }
            document.querySelector("#failed-mugshot").style.display = "flex";
        } else {
            existingCard.classList.add("failed");
        }
    
        existingCard.style.filter = "blur(0px)";
    }
})

const setPlayerCard = (index) => {
    const cardData = playerChars[index];
    if (cardData) {
        if (document.querySelector("#create-char-container").style.display == "flex") {
            document.querySelector("#create-char-container").style.opacity = "0";
            createCharMenu = false;
            setTimeout(() => {
                document.querySelector("#create-char-container").style.display = "none";
            }, 250);
        }
        charactersAmount.innerText = `${index+1}/${playerChars.length}`; 
        document.querySelector("#player-name").innerText = cardData.charName;
        if (typeof cardData.charGender == "number") {
            const stringGender = parseInt(cardData.charGender) == 0 ? "Male" : "Female"; 
            document.querySelector("#gender").innerText = cardData.charNationality + " " + stringGender;
        } else {
            document.querySelector("#gender").innerText = cardData.charNationality + " " + cardData.charGender[0].toUpperCase() + cardData.charGender.substring(1);
        }
        document.querySelector("#phone").innerText = cardData.charPhone;
        document.querySelector("#player-job").innerText = cardData.charJob[0].toUpperCase() + cardData.charJob.substring(1);
        document.querySelector("#citizenid").innerText = `CitizenID: ${cardData.citizenId}`
        existingCard.dataset.citizenId = cardData.citizenId;
        if (playerChars.length == parseInt(index) + 1) {
            rightButton.classList = "fas fa-plus-square";
        }

        fetch(`https://idz-multicharacter/pedChange`, {
            method: 'POST',
            headers: {"Content-Type": "application/json; charset=UTF-8"},
            body: JSON.stringify({
                cardData : cardData,
                charId : cardData.citizenId,
            })
        });    
    }
}


document.querySelector("#left-blur").onmouseenter = () => {
    document.querySelector("#left-blur").style.opacity = "1";
}
document.querySelector("#left-blur").onmouseleave = () => {
    if (canPress) {
    document.querySelector("#left-blur").style.opacity = "0";
    }
}
document.querySelector("#right-blur").onmouseenter = () => {
    if (canPress) {
        document.querySelector("#right-blur").style.opacity = "1";
    }
}
document.querySelector("#right-blur").onmouseleave = () => {
    if (canPress) {
        document.querySelector("#right-blur").style.opacity = "0";
    }
}

let createCharMenu = false;
let clearingTimeout;
let emoteTimeout;
let fastClickTimeout; 
let [leftPressed, rightPressed] = [false, false];
document.onkeydown = (e) => {
    if (canPress) {
        if (!createCharMenu) {
            if (parseInt(e.key) && parseInt(e.key) - 1 != currentIndex) {
                if (playerChars[parseInt(e.key) - 1] && !fastClickTimeout && !loaderShowing) {
                    fastClickTimeout = setTimeout(() => {
                        fastClickTimeout = undefined
                    }, 1500);         
                    currentIndex = parseInt(e.key) - 1;
                    if (rightButton.classList == "fas fa-plus-square") {
                        rightButton.classList = "fas fa-caret-square-right";
                    }            
                    setPlayerCard(currentIndex);
                }
            }    
        }
        if (e.keyCode == emoteKey && !emoteTimeout && !createCharMenu && !loaderShowing) {
            fetch(`https://idz-multicharacter/emote`, {
                method: 'POST',
                headers: {"Content-Type": "application/json; charset=UTF-8"},
                body: JSON.stringify(playerChars[currentIndex])
            });        
            emoteTimeout = setTimeout(() => {
                emoteTimeout = undefined
            }, 2500);
        }
        if (e.key == "ArrowLeft" && !clearingTimeout && !leftPressed && !loaderShowing) {
            clearingTimeout = setTimeout(() => {
                clearingTimeout = undefined
            }, 1500); 
            if (currentIndex <= 0) return;
            currentIndex--;
            setPlayerCard(currentIndex);
            leftPressed = true;
        }
        if (e.key == "ArrowRight" && !clearingTimeout && !rightPressed && !loaderShowing) {
            clearingTimeout = setTimeout(() => {
                clearingTimeout = undefined
            }, 1500); 
            const maxLength = playerChars.length;
            if (currentIndex == maxLength-1) return;
            currentIndex++;
            setPlayerCard(currentIndex)
            rightPressed = true;
        }
    }
    if (createCharMenu) {
        if (e.key == "Escape") {
            document.querySelector("#create-char-container").style.opacity = "0";
            createCharMenu = false;
            setTimeout(() => {
                document.querySelector("#create-char-container").style.display = "none";
            }, 250);        
        }
    }
}

document.onkeyup = (e) => {
    if (canPress) {
        if (e.key == "ArrowLeft") {
            leftPressed = false;
        }
        if (e.key == "ArrowRight") {
            rightPressed = false;
        } 
    }
}

leftButton.onclick = () => {
    if (!loaderShowing) {
        if (currentIndex <= 0) return;
        if (rightButton.classList == "fas fa-plus-square") {
            rightButton.classList = "fas fa-caret-square-right";
        }
        currentIndex--;
        setPlayerCard(currentIndex);    
    }
}

rightButton.onclick = () => {
    if (!loaderShowing) {
        if (rightButton.classList == "fas fa-plus-square") { 
            document.querySelector("#create-char-container").style.display = "flex";
            document.querySelector("#create-char-container").style.opacity = "0";
            createCharMenu = true;
            setTimeout(() => {
                document.querySelector("#create-char-container").style.opacity = "1";
                
            }, 25);    
        } else {
            const maxLength = playerChars.length;
            if (currentIndex == maxLength-1) {
                rightButton.classList = "fas fa-plus-square";
            } else {
                currentIndex++;
                setPlayerCard(currentIndex)
            }    
        }
    }
}

document.querySelector("#card-join").onclick = () => {
    canPress = false;
    clearingTimeout = undefined; 
    fastClickTimeout = undefined;
    leftPressed = false;
    rightPressed = false;
    leftButton.style.display = "none";
    rightButton.style.display = "none";
    document.querySelector("#failed-mugshot").style.display = "none";
    existingCard.classList.remove("failed");
    existingCard.style.display = "none";
    charactersAmount.innerText = "";
    document.querySelector("#right-blur").style.opacity = "0";
    document.querySelector("#left-blur").style.opacity = "0";
    document.querySelector("#blur-circle").style.display = "none";
    rightButton.classList = "fas fa-caret-square-right";
    const citizenId =  existingCard.dataset.citizenId;
    fetch(`https://idz-multicharacter/joinChar`, {
        method: 'POST',
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: JSON.stringify({
            charId : citizenId
        })
    });
}

document.querySelector("#delete-char").onclick = () => {
    document.querySelector("#create-char-container").style.opacity = "0";
    createCharMenu = false;
    setTimeout(() => {
        document.querySelector("#create-char-container").style.display = "none";
    }, 250);
}

newCharCard.onclick = () => {
    document.querySelector("#create-char-container").style.display = "flex";
    document.querySelector("#create-char-container").style.opacity = "0";
    createCharMenu = true;
    setTimeout(() => {
        document.querySelector("#create-char-container").style.opacity = "1";
    }, 25);
}

let deleteMenu = false
deleteButton.onclick = () => {
    if (deleteMenu) return 
    deleteMenu = true 
    document.querySelector("#confirm-container").style.display = "flex"; 

    document.querySelector("#card-confirm").onclick = () => {
        const citizenId =  existingCard.dataset.citizenId;
        deleteMenu = false
        document.querySelector("#confirm-container").style.display = "none"; 
        canPress = false;
        clearingTimeout = undefined; 
        fastClickTimeout = undefined;
        leftPressed = false;
        rightPressed = false;
        leftButton.style.display = "none";
        rightButton.style.display = "none";
        document.querySelector("#failed-mugshot").style.display = "none";
        existingCard.classList.remove("failed");
        existingCard.style.display = "none";
        charactersAmount.innerText = "";   
        document.querySelector("#right-blur").style.opacity = "0";
        document.querySelector("#left-blur").style.opacity = "0";   
        document.querySelector("#blur-circle").style.display = "none";
        rightButton.classList = "fas fa-caret-square-right";  
        fetch(`https://idz-multicharacter/deleteChar`, {
            method: 'POST',
            headers: {"Content-Type": "application/json; charset=UTF-8"},
            body: JSON.stringify({
                charId : citizenId
            })
        });    
    }

    document.querySelector("#card-deny").onclick = () => {
        deleteMenu = false
        document.querySelector("#confirm-container").style.display = "none"; 
    }   
}

let selectedGender = 0;

document.querySelector("#create-char").onclick = () => {
    document.querySelector("#create-char-container").style.opacity = "0";
    createCharMenu = false;
    setTimeout(() => {
        document.querySelector("#create-char-container").style.display = "none";
    }, 250);

    

    fetch(`https://idz-multicharacter/checkCreation`, {
        method: 'POST',
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: JSON.stringify({
            currentAmount: parseInt(playerChars.length)
        })
    }).then(resp => resp.json()).then(resp => {
        if (resp.canCreate) {
            const inputName = document.querySelector("#input-name").value.toString().split(" ");
            const inputBirth = document.querySelector("#input-birth").value;
            const firstName = inputName[0];
            const nationality = document.querySelector("#input-nationality").value;
            let lastName = "";
            for (let index = 1; index < inputName.length; index++) {
                lastName = lastName + inputName[index] + " ";
            }
        
            document.querySelector("#input-name").value = "";
            document.querySelector("#input-birth").value = "";
            document.querySelector("#input-nationality").value = "";
        
            let continueApprove = true
            if (firstName == "" || lastName == "") {
                continueApprove = false
                fetch(`https://idz-multicharacter/notifyError`, {
                    method: 'POST',
                    headers: {"Content-Type": "application/json; charset=UTF-8"},
                    body: JSON.stringify("You didn't fill your character's first/last name.")
                });
            
            }
            if (inputBirth == "") {
                continueApprove = false
                fetch(`https://idz-multicharacter/notifyError`, {
                    method: 'POST',
                    headers: {"Content-Type": "application/json; charset=UTF-8"},
                    body: JSON.stringify("You didn't fill your character's birthdate")
                });
            } 
        
            if (nationality == "") {
                continueApprove = false
                fetch(`https://idz-multicharacter/notifyError`, {
                    method: 'POST',
                    headers: {"Content-Type": "application/json; charset=UTF-8"},
                    body: JSON.stringify("You didn't fill your character's nationality")
                });
            }
        
            if (!continueApprove) return 
            canPress = false;
            clearingTimeout = undefined; 
            fastClickTimeout = undefined;
            leftPressed = false;
            rightPressed = false;
            leftButton.style.display = "none";
            rightButton.style.display = "none";
            document.querySelector("#failed-mugshot").style.display = "none";
            existingCard.classList.remove("failed");
            existingCard.style.display = "none";
            charactersAmount.innerText = "";   
            document.querySelector("#right-blur").style.opacity = "0";
            document.querySelector("#left-blur").style.opacity = "0";   
            document.querySelector("#blur-circle").style.display = "none";  
            newCharCard.style.display = "none";
            rightButton.classList = "fas fa-caret-square-right";        
            fetch(`https://idz-multicharacter/createChar`, {
                method: 'POST',
                headers: {"Content-Type": "application/json; charset=UTF-8"},
                body: JSON.stringify({
                    firstname: firstName,
                    lastname: lastName.substring(0, lastName.length - 1),
                    nationality: nationality,
                    birthdate: inputBirth,
                    gender: parseInt(selectedGender)
                })
            });        
        }
    });

}


document.querySelector("#gender-male").onclick = () => {
    selectedGender = 0;
    document.querySelector("#gender-female").style.backgroundColor = "#1D1D1D";
    document.querySelector("#gender-male").style.backgroundColor = "#2D2D2D";
}

document.querySelector("#gender-female").onclick = () => {
    selectedGender = 1;
    document.querySelector("#gender-male").style.backgroundColor = "#1D1D1D";
    document.querySelector("#gender-female").style.backgroundColor = "#2D2D2D";
}



