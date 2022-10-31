// A MongoDB script that creates an administrative MongoDB user

logger = (message, type = "INFO") => {
    const stackLine = new Error().stack.split("\n")[1].split("/").slice(-1)[0];
    print(`[${stackLine.split(":").slice(0, -1).join(":")}] [${type}] ${message}`);
}

if (typeof username === 'undefined' || typeof password === 'undefined') {
    logger(
        "Please define 'username' and 'password' before running this script",
        "ERROR"
    )
    quit(1)
} 

const conn = new Mongo();

const db = conn.getDB("admin");

const userProperties = {
    pwd: password,
    roles: [
        { role: "userAdminAnyDatabase", db: "admin" },
        { role: "readWriteAnyDatabase", db: "admin" }
    ]
}

const userExists = db.getUser(username);

if (userExists) {
    db.updateUser(username, userProperties);
} else {
    db.createUser({ ...userProperties, "user": username });
}

logger(`${userExists ? "Updated" : "Created"} ${username} user`);
