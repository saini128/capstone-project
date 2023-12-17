import { initializeApp } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js";
import { getFirestore, collection, getDocs } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-firestore.js";

const firebaseConfig = {
  apiKey: "",
  authDomain: "",
  projectId: "",
  storageBucket: "",
  messagingSenderId: "",
  appId: ""
};


const app = initializeApp(firebaseConfig);


const db = getFirestore();


const usersCollection = collection(db, 'users');


async function fetchAndDisplayUsers() {
  try {
    
    const querySnapshot = await getDocs(usersCollection);

    
    displayUsers(querySnapshot.docs);
  } catch (error) {
    console.error("Error fetching documents: ", error);
  }
}


function displayUsers(users) {
  
  const userList = document.getElementById('cafe-list');

  
  userList.innerHTML = '';

  
  users.forEach((user) => {
    const userData = user.data();
    
    
    console.log("User Data:", userData);

    
    const tableRow = document.createElement('tr');

    
    tableRow.innerHTML = `
      <td>${userData.name || "N/A"}</td>
      <td>${userData.email || "N/A"}</td>
      <td>${userData.phone || "N/A"}</td>
      <td>${userData.role || "N/A"}</td>
      <td>${userData.amount !== undefined ? userData.amount : "N/A"}</td>
      <td>${userData.id || "N/A"}</td>
    `;

    
    userList.appendChild(tableRow);
  });
}


fetchAndDisplayUsers();





window.sortTable = function (columnIndex) {
    const table = document.getElementById("cafe-table");
    const tbody = document.getElementById("cafe-list");
    const rows = Array.from(tbody.rows);
  
    
    const isAscending = table.getAttribute("data-sorted") === "asc";
  
    rows.sort((a, b) => {
      const cellA = a.cells[columnIndex].innerText.trim();
      const cellB = b.cells[columnIndex].innerText.trim();
  
      let comparisonResult;
  
      if (!isNaN(cellA) && !isNaN(cellB)) {
        comparisonResult = parseFloat(cellA) - parseFloat(cellB);
      } else {
        comparisonResult = cellA.localeCompare(cellB);
      }
  
      
      return isAscending ? comparisonResult : -comparisonResult;
    });
  
    
    tbody.innerHTML = '';
  
    
    rows.forEach((row) => tbody.appendChild(row));
  
    
    table.setAttribute("data-sorted", isAscending ? "desc" : "asc");
  
    
    table.appendChild(tbody);
  };
  
  
  


document.getElementById('search-input').addEventListener('input', function () {
  const searchValue = this.value.toLowerCase();

  const table = document.getElementById('cafe-table');
  const rows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr');

  for (const row of rows) {
    let found = false;

    for (const cell of row.cells) {
      if (cell.innerText.toLowerCase().includes(searchValue)) {
        found = true;
        break;
      }
    }

    row.style.display = found ? '' : 'none';
  }
});
