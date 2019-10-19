$(function () {
    $("#plotdiv").resizable()

    let n_samples = parseInt($("#n_val").val());
    let dist_abbr = "unif";
    let dist_name = "Uniform"

    $("#view_n").html(n_samples);
    $("#view_d").html(dist_name);

    function runR() {
        let req = $("#plotdiv").rplot("plotdist", {
            n: n_samples,
            dist: dist_abbr
        }).fail(function () {
            alert("HTTP error " + req.status + ": " + req.responseText);
        });
    }

    function doClick(event) {
        event.preventDefault();
        n_samples = parseInt($("#n_val").val());
        dist_abbr = event.data.dist;
        dist_name = event.data.name;
        $("#view_d").html(dist_name);
        console.log(n_samples, dist_abbr, dist_name)
        runR()
    };

    function doSlide(event) {
        n_samples = parseInt($("#n_val").val());
        $("#view_n").html(n_samples);
    }

    $("#unifbtn").on('click', {
        dist: "unif",
        name: "Uniform"
    }, doClick)
    $("#normbtn").on('click', {
        dist: "norm",
        name: "Normal"
    }, doClick)
    $("#chisqbtn").on('click', {
        dist: "chisq",
        name: "Chi-Squared"
    }, doClick)
    $("#expbtn").on('click', {
        dist: "exp",
        name: "Exponential"
    }, doClick)
    $("#n_val").on('input', doSlide)
});