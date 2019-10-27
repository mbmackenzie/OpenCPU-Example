$(function () {
    $("#plotdiv").resizable()
    $('#kde').bootstrapToggle();

    let n_samples = parseInt($("#n_val").val());
    let dist_abbr = "unif";
    let dist_name = "Uniform"
    let kde = true

    $("#view_n").html(n_samples);
    $("#view_d").html(dist_name);

    function runR(params) {
        console.log(params);
        let req = $("#plotdiv").rplot("plotdist", params).fail(function () {
            alert("HTTP error " + req.status + ": " + req.responseText);
        });
    }

    function doClick(event) {
        event.preventDefault();
        dist_abbr = event.data.dist;
        dist_name = event.data.name;
        $("#view_d").html(dist_name);

        params = {
            n: n_samples,
            kde: kde
        }

        Object.entries(event.data).forEach(([key, value]) => {
            if (value.startsWith("getParamValue")) {
                params[key] = getParamValue(value.split("-")[1]);
            } else {
                params[key] = value
            }
        });

        runR(params);
    };

    function doSlide(event) {
        n_samples = parseInt($("#n_val").val());
        if (n_samples == 0) {
            n_samples = 1;
        }
        $("#view_n").html(n_samples);
    }

    function getParamValue(id) {
        console.log(id);

        return parseFloat($(`#${id}`).val())
    }

    $("#unifbtn").on('click', {
        dist: "unif",
        name: "Uniform",
        min: "getParamValue-unifmin",
        max: "getParamValue-unifmax"
    }, doClick)

    $("#normbtn").on('click', {
        dist: "norm",
        name: "Normal",
        mean: "getParamValue-normmean",
        sd: "getParamValue-normsd"
    }, doClick)

    $("#chisqbtn").on('click', {
        dist: "chisq",
        name: "Chi-Squared",
        df: "getParamValue-chidf"
    }, doClick)

    $("#expbtn").on('click', {
        dist: "exp",
        name: "Exponential",
        rate: "getParamValue-exprate"
    }, doClick)

    $("#tbtn").on('click', {
        dist: "t",
        name: "T",
        df: "getParamValue-tdf",
        ncp: "getParamValue-tncp"
    }, doClick)

    $("#fbtn").on('click', {
        dist: "f",
        name: "F",
        df1: "getParamValue-fdf1",
        df2: "getParamValue-fdf2"
    }, doClick)

    $("#n_val").on('input', doSlide);

    $('#kde').change(function () {
        kde = $(this).prop('checked');
    });

});