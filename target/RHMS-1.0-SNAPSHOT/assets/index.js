function onLoad() {
    const title = "RENTAL HOUSE MANAGEMENT SYSTEM";
    if (window.innerWidth <= 928) {
        $(".navbar-brand").text("RHMS");
    } else {
        $(".navbar-brand").text(title);
    }
    document.querySelectorAll("input.btn.btn-primary, #searchBtn, a.btn.btn-primary.btn-lg.px-4.me-sm-3")
        .forEach(btn => {
            btn.onmouseleave = function (evt) {
                evt.target.style.background = "#0f6674";
                //evt.target.style.borderImage = null;
            };
            btn.addEventListener("mousemove", evt => {
                const rect = evt.target.getBoundingClientRect();
                const x = evt.clientX - rect.left; //x position within the element.
                const y = evt.clientY - rect.top; //y position within the element.
                evt.target.style.background = `radial-gradient(circle at ${x}px ${y}px , rgba(120, 155, 155, 0.65),rgba(15, 102, 116, 0.7) )`;
                //evt.target.style.borderImage = `radial-gradient(20% 75% at ${x}px ${y}px ,rgba(255,255,255,0.7),rgba(255,255,255,0.1) ) 1 / 1px / 0px stretch `;
            });
        });

}

function search(event) {
    if (event.code === "Slash") document.getElementById("searchBtn").click();
}

// If `prefers-color-scheme` is not supported, fall back to light mode.
// i.e. In this case, inject the `light` CSS before the others, with
// no media filter so that it will be downloaded with highest priority.
function darkTheme() {
    if (window.matchMedia("(prefers-color-scheme: dark)").media === "not all") {
        document.documentElement.style.display = "none";
        document.head.insertAdjacentHTML(
            "beforeend",
            "<link id='css' rel='stylesheet' href='assets/bootstrap_4.5.2.css'" +
            " onload='document.documentElement.style.display = ``'>"
        );
    }
}

function setTheme() {
    let $new_mode, $dark, $other, $href, $mode;

    // Update the toggle button based on current color scheme
    function updateDarkToggleButton() {
        $dark = (window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches);
        $("#css-toggle-btn").prop("checked", $dark);
        navTheme($dark ? "dark" : "light");
    }

    // Update on first load.
    updateDarkToggleButton();
    // and every time it changes
    if (window.matchMedia) window.matchMedia("(prefers-color-scheme: dark)")
        .addListener(updateDarkToggleButton);

    // Color Scheme toggle botton

    // function to initialise the css
    function init_color_scheme_css($id, $mode) {
        if ($("#" + $id)) $("#" + $id).remove();  // remove exitsing id
        $("#" + $id + "-" + $mode).attr({
            "data-href-light": $("#" + $id + "-light").attr("href"),  // store the light CSS url
            "data-href-dark": $("#" + $id + "-dark").attr("href"), // store the dark CSS url
            "data-color-scheme": $mode,  // store the mode, so that we don't re-initalise
            "media": "all",  // drop the media filter
            "id": $id  // rename the id (drop the `-{mode}` bit)
        });
        $other = ($mode === 'dark') ? 'light' : 'dark';
        $("#" + $id + "-" + $other).remove();
    }

    // function to toggle the CSS
    function toggle_color_scheme_css($id, $mode) {
        // grab the new mode css href
        $href = $("#" + $id).data("href-" + $mode);  // use `.data()` here, leverage the cache
        // set the CSS to the mode preference.
        $("#" + $id).attr({
            "href": $href,
            "data-color-scheme": $mode,
        });
    }

    // toggle button click code
    $("#css-toggle-btn").bind("click", function () {
        // get current mode
        // don't use `.data("color-scheme")`, it doesn't refresh
        $mode = $("#css").attr("data-color-scheme");
        // test if this is a first time click event, if so initialise the code
        if (typeof $mode === 'undefined') {
            // not defined yet - set pref. & ask the browser if alt. is active
            $mode = 'light';
            if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches)
                $mode = 'dark';
            init_color_scheme_css("css", $mode);
            // `init_color_scheme_css()` any other CSS
        }
        // by here we have the current mode, so swap it
        $new_mode = ($mode === 'dark') ? 'light' : 'dark';
        toggle_color_scheme_css("css", $new_mode);
        // `toggle_color_scheme_css()` any other CSS
        localStorage.setItem("theme", $new_mode);
        navTheme($new_mode);
    });
    if ((localStorage.getItem("theme") === "light" &&
            (window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches)) ||
        (localStorage.getItem("theme") === "dark" &&
            !(window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches)))
        document.getElementById("css-toggle-btn").click();
}

function navTheme(mode) {
    try {
        let navLink = document.getElementsByClassName("nav-link"),
            navBrand = document.getElementById("brand"),
            navBar = document.getElementById("navbar");
        if (mode === "dark") {
            navBar.style.backgroundColor = "rgba(52, 53, 56, .75)";
            for (let i = 0; i < navLink.length; i++) {
                navLink[i].style.setProperty("color", "#fafafa", "important");
                navLink[i].addEventListener("mouseover", () => {
                    navLink[i].style.setProperty("opacity", "0.5", "important");
                });
                navLink[i].addEventListener("mousedown", () => {
                    navLink[i].style.setProperty("opacity", "0.5", "important");
                });
                navLink[i].addEventListener("mouseout", () => {
                    navLink[i].style.setProperty("opacity", null, "important");
                });
            }
            navBrand.style.setProperty("color", "#fafafa", "important");
            navBrand.addEventListener("mouseover", () => {
                navBrand.style.setProperty("opacity", "0.5", "important");
            });
            navBrand.addEventListener("mousedown", () => {
                navBrand.style.setProperty("opacity", "0.5", "important");
            });
            navBrand.addEventListener("mouseout", () => {
                navBrand.style.setProperty("opacity", null, "important");
            });
            document.getElementsByClassName("bg-light")[1].style.setProperty("filter", "invert(100%)");
        } else {
            navBar.style.backgroundColor = "rgba(255, 255, 255, .75)";
            for (let i = 0; i < navLink.length; i++) {
                navLink[i].style.setProperty("color", null, "important");
                navLink[i].addEventListener("mouseover", () => {
                    navLink[i].style.setProperty("opacity", null, "important");
                });
                navLink[i].addEventListener("mousedown", () => {
                    navLink[i].style.setProperty("opacity", null, "important");
                });
            }
            navBrand.style.setProperty("color", null, "important");
            navBrand.addEventListener("mouseover", () => {
                navBrand.style.setProperty("opacity", null, "important");
            });
            navBrand.addEventListener("mousedown", () => {
                navBrand.style.setProperty("opacity", null, "important");
            });
            document.getElementsByClassName("bg-light")[1].style.setProperty("filter", "");
        }
    } catch (e) {
    }
}

function recordUtils() {
    // create references to the modal...
    const modal = document.getElementById('myImageModal');
    // to all images -- bear in mind I'm using a class!
    const images = document.getElementsByClassName('myImaging');
    // the image in the modal
    const modalImg = document.getElementById("image01");
    // and the caption in the modal
    const captionText = document.getElementById("caption01"),
        span = document.getElementsByClassName("closable")[0],
        footer = document.querySelector("footer"),
        container = document.querySelector(".container"),
        navbar = document.querySelector("nav.navbar.navbar-expand-md.navbar-light.bg-light.fixed-top");

    // Go through all of the images with our custom class
    for (let i = 0; i < images.length; i++) {
        const img = images[i];
        img.onclick = function (evt) {
            // and attach our click listener for this image.
            // console.log(evt);
            modal.style.display = "block";
            document.body.style.overflow = "hidden";
            modalImg.src = this.src;
            captionText.innerHTML = this.alt;
            footer.style.filter = "blur(12px)";
            container.style.filter = "blur(12px)";
            navbar.style.filter = "blur(12px)";
        }
    }

    span.onclick = function () {
        modal.style.display = "none";
        document.body.style.overflow = "";
        footer.style.filter = null;
        container.style.filter = null;
        navbar.style.filter = null;
    }
    // When the user clicks anywhere outside of the modal, close it
    window.onclick = function (event) {
        if (event.target === modal) {
            modal.style.display = "none";
            document.body.style.overflow = "";
            footer.style.filter = null;
            container.style.filter = null;
            navbar.style.filter = null;
        }
    }

}

function fixLinkBugs() {
    const logOut = document.getElementById("logout"),
        login = document.getElementById("login");

    if (logOut) {
        logOut.addEventListener("click", () => location.href = "LogOut");
    }
    if (login) {
        login.addEventListener("click", () => location.href = "login.jsp");
    }
}

function uploadUtils() {
    const dropZone = document.getElementById('imager'), preview = document.getElementById("preview"),
        fileField = document.getElementById("fileField"), img = document.createElement('img'),
        imageSpan = document.getElementById("imageSpan");
    dropZone.addEventListener("mouseover", () => imageSpan.innerText = "Pick an image");
    dropZone.addEventListener("mouseleave", () => imageSpan.innerText = "Image Preview");
    dropZone.addEventListener("click", () => fileField.click());

    // Optional.   Show the copy icon when dragging over.  Seems to only work for chrome.
    dropZone.addEventListener('dragover', function (e) {
        e.stopPropagation();
        e.preventDefault();
        e.dataTransfer.dropEffect = 'copy';
        dropZone.classList.add('dragging');
    });
    dropZone.addEventListener('dragleave', () => {
        dropZone.classList.remove('dragging');
    });
    // Get file data on drop
    dropZone.addEventListener('drop', function (e) {
        e.stopPropagation();
        e.preventDefault();
        dropZone.classList.remove('dragging');
        fileField.files = e.dataTransfer.files;
        const files = e.dataTransfer.files; // Array of all files
        for (let i = 0, file; file = files[i]; i++) {
            if (file.type.match(/image.*/)) {
                const reader = new FileReader();
                reader.onload = function (e2) {
                    img.src = e2.target.result;
                    preview.setAttribute("src", img.src);
                    preview.style.display = "block";
                    imageSpan.style.display = "none";
                }
                reader.readAsDataURL(file);
            }
        }
    });
    fileField.oninput = function () {
        const file = this.files[0];
        if (file) {
            const reader = new FileReader();
            preview.style.display = "block";
            reader.addEventListener("load", function () {
                console.log(this);
                preview.removeAttribute("src");
                preview.setAttribute("src", this.result);
            })
            reader.readAsDataURL(file);
            console.log(file.size);
            imageSpan.style.display = "none";
            if (parseInt(file.size) > 8388608) {
                alert("This image file is too big. The maximum file size is 8MB.");
                fileField.value = "";
                imageSpan.style.display = "table-cell";
                preview.style.display = "none";
            }

            const filePath = fileField.value;
            // Allowing file type
            const allowedExtensions = /(\.jpg|\.jpeg|\.png|\.gif)$/i;
            if (!allowedExtensions.exec(filePath)) {
                alert('Uploaded file is not an image.');
                fileField.value = '';
                imageSpan.style.display = "table-cell";
                preview.style.display = "none";
                fileField.style.borderColor = "#eb4034";
                fileField.style.borderWidth = "3px";
                fileField.focus();
            }
        } else {
            imageSpan.style.display = "table-cell";
            preview.style.display = "none";
        }
    }
}