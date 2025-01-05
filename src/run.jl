"""
    run()

Execute the code to replicate Duflo, & al (2008) and save results in output folder
"""
function run()
    fig1 = figure1()
    savefig(fig1, "output/figure1.png")

    fig2 = figure2()
    savefig(fig2, "output/figure2.png")

    fig3 = figure3()
    savefig(fig3, "output/figure3.png")
end